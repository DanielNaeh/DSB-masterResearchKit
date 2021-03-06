////////////////////////////////////////////////////////////////////////////
//
// Copyright 2019 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_OS_UTIL_EVENT_LOOP_DISPATCHER_HPP
#define REALM_OS_UTIL_EVENT_LOOP_DISPATCHER_HPP

#include "util/event_loop_signal.hpp"

#include <mutex>
#include <queue>
#include <tuple>

namespace realm {
// FIXME: remove once we switch to C++ 17 where we can use std::apply
namespace _apply_polyfill {
template <class Tuple, class F, size_t... Is>
constexpr auto apply_impl(Tuple&& t, F f, std::index_sequence<Is...>) {
    return f(std::get<Is>(std::forward<Tuple>(t))...);
}

template <class Tuple, class F>
constexpr auto apply(Tuple&& t, F f) {
    return apply_impl(std::forward<Tuple>(t), f, std::make_index_sequence<std::tuple_size<Tuple>{}>{});
}
}

namespace util {
template <class F>
class EventLoopDispatcher;

template <typename... Args>
class EventLoopDispatcher<void(Args...)> {
    using Tuple = std::tuple<typename std::remove_reference<Args>::type...>;
private:
    struct Callback;

    struct State {
    public:
        State(std::function<void(Args...)> func)
        : m_func(std::move(func))
        {
        }

        const std::function<void(Args...)> m_func;
        std::queue<Tuple> m_invocations;
        std::mutex m_mutex;
        std::shared_ptr<EventLoopSignal<Callback>> m_signal;
    };
    const std::shared_ptr<State> m_state;

    struct Callback {
        void operator()()
        {
            std::unique_lock<std::mutex> lock(m_state->m_mutex);
            while (!m_state->m_invocations.empty()) {
                auto& tuple = m_state->m_invocations.front();
                _apply_polyfill::apply(std::move(tuple), m_state->m_func);
                m_state->m_invocations.pop();
            }
            m_state->m_signal.reset();
        }

        std::shared_ptr<State> m_state;
    };
    const std::shared_ptr<EventLoopSignal<Callback>> m_signal;
    const std::thread::id m_thread = std::this_thread::get_id();

public:
    EventLoopDispatcher(std::function<void(Args...)> func)
    : m_state(std::make_shared<State>(func))
    , m_signal(std::make_shared<EventLoopSignal<Callback>>(Callback{m_state}))
    {
    }

    const std::function<void(Args...)>& func() const { return m_state->m_func; }

    void operator()(Args... args)
    {
        if (m_thread == std::this_thread::get_id()) {
            m_state->m_func(std::forward<Args>(args)...);
            return;
        }

        {
            std::unique_lock<std::mutex> lock(m_state->m_mutex);
            m_state->m_signal = m_signal;
            m_state->m_invocations.push(std::make_tuple(std::forward<Args>(args)...));
        }
        m_signal->notify();
    }
};
} // namespace util
} // namespace realm

#endif

