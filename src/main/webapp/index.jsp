<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <link rel="icon" href="coffeeicon.ico" type="image/x-icon">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TODO — Get Things Done</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        *,
        *::before,
        *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-deep: #080012;
            --bg-dark: #110024;
            --purple-vivid: #a855f7;
            --purple-bright: #c084fc;
            --purple-glow: #d8b4fe;
            --pink-hot: #ec4899;
            --pink-light: #f9a8d4;
            --violet-deep: #7c3aed;
            --indigo: #6366f1;
            --cyan-accent: #22d3ee;
            --glass-bg: rgba(255, 255, 255, 0.06);
            --glass-border: rgba(168, 85, 247, 0.3);
            --text-primary: #f5f0ff;
            --text-secondary: #c9b8e8;
            --text-muted: #8b72b0;
            --danger: #fb7185;
            --success: #34d399;
            --radius: 18px;
            --radius-sm: 10px;
            --shadow-big: 0 30px 80px rgba(0, 0, 0, 0.6), 0 0 50px rgba(168, 85, 247, 0.2);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            min-height: 100vh;
            background: var(--bg-deep);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-family: 'Outfit', sans-serif;
            color: var(--text-primary);
            padding: 32px 20px;
            overflow-x: hidden;
            position: relative;
        }

        /* === Animated gradient mesh background === */
        .bg-mesh {
            position: fixed;
            inset: 0;
            z-index: 0;
            overflow: hidden;
        }

        .bg-mesh .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(100px);
            opacity: 0.5;
        }

        .bg-mesh .orb:nth-child(1) {
            width: 500px;
            height: 500px;
            background: var(--purple-vivid);
            top: -15%;
            left: -10%;
            animation: orb-move-1 12s ease-in-out infinite alternate;
        }

        .bg-mesh .orb:nth-child(2) {
            width: 400px;
            height: 400px;
            background: var(--pink-hot);
            bottom: -10%;
            right: -10%;
            animation: orb-move-2 10s ease-in-out infinite alternate;
        }

        .bg-mesh .orb:nth-child(3) {
            width: 350px;
            height: 350px;
            background: var(--indigo);
            top: 40%;
            left: 50%;
            animation: orb-move-3 14s ease-in-out infinite alternate;
        }

        .bg-mesh .orb:nth-child(4) {
            width: 250px;
            height: 250px;
            background: var(--cyan-accent);
            top: 10%;
            right: 20%;
            opacity: 0.25;
            animation: orb-move-4 11s ease-in-out infinite alternate;
        }

        @keyframes orb-move-1 {
            0% {
                transform: translate(0, 0) scale(1);
            }

            100% {
                transform: translate(80px, 60px) scale(1.15);
            }
        }

        @keyframes orb-move-2 {
            0% {
                transform: translate(0, 0) scale(1);
            }

            100% {
                transform: translate(-60px, -50px) scale(1.1);
            }
        }

        @keyframes orb-move-3 {
            0% {
                transform: translate(0, 0) scale(1);
            }

            100% {
                transform: translate(-40px, 30px) scale(0.9);
            }
        }

        @keyframes orb-move-4 {
            0% {
                transform: translate(0, 0) scale(1);
            }

            100% {
                transform: translate(30px, -40px) scale(1.2);
            }
        }

        /* === App container === */
        .app {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 560px;
            animation: page-enter 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes page-enter {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.96);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* === Header === */
        .header {
            text-align: center;
            margin-bottom: 32px;
            animation: header-float 6s ease-in-out infinite;
        }

        @keyframes header-float {

            0%,
            100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-6px);
            }
        }

        .header .logo {
            width: 72px;
            height: 72px;
            margin: 0 auto 14px;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--purple-vivid), var(--pink-hot), var(--indigo));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            box-shadow: 0 8px 30px rgba(168, 85, 247, 0.45);
            animation: logo-pulse 3s ease-in-out infinite;
        }

        @keyframes logo-pulse {

            0%,
            100% {
                transform: scale(1);
                box-shadow: 0 8px 30px rgba(168, 85, 247, 0.45);
            }

            50% {
                transform: scale(1.06);
                box-shadow: 0 12px 40px rgba(236, 72, 153, 0.5);
            }
        }

        .header h1 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 2.6rem;
            font-weight: 700;
            letter-spacing: -1px;
            background: linear-gradient(135deg, #f5f0ff 0%, var(--purple-glow) 40%, var(--pink-light) 70%, var(--cyan-accent) 100%);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: gradient-shift 4s ease infinite;
        }

        @keyframes gradient-shift {

            0%,
            100% {
                background-position: 0% center;
            }

            50% {
                background-position: 100% center;
            }
        }

        .header p {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-top: 6px;
            font-weight: 300;
            letter-spacing: 0.03em;
        }

        /* === Card === */
        .card {
            background: var(--glass-bg);
            backdrop-filter: blur(28px) saturate(1.4);
            -webkit-backdrop-filter: blur(28px) saturate(1.4);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius);
            padding: 32px 28px;
            box-shadow: var(--shadow-big);
            position: relative;
            overflow: hidden;
        }

        /* Subtle inner shine */
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
        }

        /* === Stats bar === */
        .stats-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
        }

        .stat {
            flex: 1;
            background: linear-gradient(145deg, rgba(168, 85, 247, 0.12), rgba(236, 72, 153, 0.08));
            border: 1px solid rgba(168, 85, 247, 0.2);
            border-radius: 14px;
            padding: 14px 10px;
            text-align: center;
            transition: var(--transition);
        }

        .stat:hover {
            transform: translateY(-2px);
            border-color: rgba(168, 85, 247, 0.4);
            box-shadow: 0 6px 20px rgba(168, 85, 247, 0.15);
        }

        .stat-value {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--purple-bright), var(--pink-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1;
        }

        .stat-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-top: 4px;
            font-weight: 500;
        }

        /* === Progress bar === */
        .progress-wrap {
            margin-bottom: 24px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.78rem;
            color: var(--text-muted);
            margin-bottom: 8px;
            font-weight: 500;
        }

        .progress-track {
            height: 8px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 99px;
            overflow: hidden;
            position: relative;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--violet-deep), var(--purple-vivid), var(--pink-hot));
            background-size: 200% 100%;
            border-radius: 99px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 0 14px rgba(168, 85, 247, 0.6);
            animation: progress-glow 2s ease-in-out infinite;
        }

        @keyframes progress-glow {

            0%,
            100% {
                background-position: 0% center;
            }

            50% {
                background-position: 100% center;
            }
        }

        /* === Input form === */
        .input-row {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
        }

        .input-wrap {
            flex: 1;
            position: relative;
        }

        .input-wrap .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
            pointer-events: none;
            transition: var(--transition);
        }

        input[type="text"] {
            width: 100%;
            padding: 14px 16px 14px 42px;
            background: rgba(255, 255, 255, 0.05);
            border: 1.5px solid rgba(168, 85, 247, 0.2);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            font-size: 1rem;
            font-family: 'Outfit', sans-serif;
            outline: none;
            transition: var(--transition);
        }

        input[type="text"]::placeholder {
            color: var(--text-muted);
            font-weight: 300;
        }

        input[type="text"]:focus {
            border-color: var(--purple-vivid);
            background: rgba(168, 85, 247, 0.08);
            box-shadow: 0 0 0 4px rgba(168, 85, 247, 0.15), 0 0 20px rgba(168, 85, 247, 0.1);
        }

        input[type="text"]:focus~.input-icon {
            color: var(--purple-bright);
            transform: translateY(-50%) scale(1.1);
        }

        .btn-add {
            padding: 14px 24px;
            background: linear-gradient(135deg, var(--purple-vivid), var(--pink-hot));
            border: none;
            border-radius: var(--radius-sm);
            color: white;
            font-size: 1rem;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            transition: var(--transition);
            white-space: nowrap;
            box-shadow: 0 4px 20px rgba(168, 85, 247, 0.4);
            position: relative;
            overflow: hidden;
        }

        .btn-add::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--pink-hot), var(--purple-vivid));
            opacity: 0;
            transition: opacity 0.3s;
        }

        .btn-add:hover::before {
            opacity: 1;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(236, 72, 153, 0.5);
        }

        .btn-add:active {
            transform: translateY(0);
        }

        .btn-add span {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* === Filter tabs === */
        .filter-tabs {
            display: flex;
            gap: 6px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: var(--radius-sm);
            padding: 4px;
        }

        .filter-tab {
            flex: 1;
            padding: 8px 6px;
            background: transparent;
            border: none;
            border-radius: 8px;
            color: var(--text-muted);
            font-size: 0.82rem;
            font-family: 'Outfit', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-align: center;
        }

        .filter-tab.active {
            background: linear-gradient(135deg, rgba(168, 85, 247, 0.25), rgba(236, 72, 153, 0.15));
            color: var(--purple-glow);
            box-shadow: 0 2px 10px rgba(168, 85, 247, 0.2);
        }

        .filter-tab:not(.active):hover {
            color: var(--text-secondary);
            background: rgba(255, 255, 255, 0.04);
        }

        /* === Task list === */
        #tasks {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 420px;
            overflow-y: auto;
            padding-right: 4px;
        }

        #tasks::-webkit-scrollbar {
            width: 4px;
        }

        #tasks::-webkit-scrollbar-track {
            background: transparent;
        }

        #tasks::-webkit-scrollbar-thumb {
            background: rgba(168, 85, 247, 0.3);
            border-radius: 99px;
        }

        #tasks li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 14px;
            transition: var(--transition);
            animation: task-enter 0.4s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes task-enter {
            from {
                opacity: 0;
                transform: translateY(-12px) scale(0.96);
                filter: blur(4px);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
                filter: blur(0);
            }
        }

        #tasks li:hover {
            background: rgba(168, 85, 247, 0.1);
            border-color: rgba(168, 85, 247, 0.25);
            transform: translateX(4px);
            box-shadow: 0 4px 16px rgba(168, 85, 247, 0.1);
        }

        /* Stagger animation per item */
        #tasks li:nth-child(1) {
            animation-delay: 0s;
        }

        #tasks li:nth-child(2) {
            animation-delay: 0.05s;
        }

        #tasks li:nth-child(3) {
            animation-delay: 0.1s;
        }

        #tasks li:nth-child(4) {
            animation-delay: 0.15s;
        }

        #tasks li:nth-child(5) {
            animation-delay: 0.2s;
        }

        #tasks li:nth-child(6) {
            animation-delay: 0.25s;
        }

        #tasks li:nth-child(7) {
            animation-delay: 0.3s;
        }

        #tasks li:nth-child(8) {
            animation-delay: 0.35s;
        }

        #tasks li:nth-child(9) {
            animation-delay: 0.4s;
        }

        #tasks li:nth-child(10) {
            animation-delay: 0.45s;
        }

        /* === Custom checkbox === */
        .custom-checkbox {
            position: relative;
            flex-shrink: 0;
            width: 22px;
            height: 22px;
        }

        .custom-checkbox input[type="checkbox"] {
            opacity: 0;
            width: 0;
            height: 0;
            position: absolute;
        }

        .custom-checkbox .checkmark {
            position: absolute;
            inset: 0;
            border: 2px solid rgba(168, 85, 247, 0.45);
            border-radius: 7px;
            background: transparent;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .custom-checkbox .checkmark:hover {
            border-color: var(--purple-vivid);
            box-shadow: 0 0 12px rgba(168, 85, 247, 0.3);
        }

        .custom-checkbox input:checked~.checkmark {
            background: linear-gradient(135deg, var(--purple-vivid), var(--pink-hot));
            border-color: transparent;
            box-shadow: 0 0 14px rgba(168, 85, 247, 0.5);
            animation: check-pop 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes check-pop {
            0% {
                transform: scale(1);
            }

            40% {
                transform: scale(1.25);
            }

            100% {
                transform: scale(1);
            }
        }

        .custom-checkbox .checkmark::after {
            content: '';
            width: 5px;
            height: 10px;
            border: 2px solid white;
            border-top: none;
            border-left: none;
            transform: rotate(45deg) scale(0);
            transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1);
            margin-top: -2px;
        }

        .custom-checkbox input:checked~.checkmark::after {
            transform: rotate(45deg) scale(1);
        }

        /* === Task text === */
        span.title {
            flex: 1;
            font-size: 1rem;
            color: var(--text-primary);
            line-height: 1.4;
            word-break: break-word;
            transition: var(--transition);
            font-weight: 400;
        }

        li.completed span.title {
            text-decoration: line-through;
            text-decoration-color: var(--text-muted);
            color: var(--text-muted);
            opacity: 0.6;
        }

        /* === Icon buttons === */
        button.icon-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-muted);
            font-size: 1.05rem;
            padding: 6px 8px;
            border-radius: 8px;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        button.icon-btn.edit:hover {
            color: var(--purple-bright);
            background: rgba(168, 85, 247, 0.15);
            transform: scale(1.1);
        }

        button.icon-btn.delete:hover {
            color: var(--danger);
            background: rgba(251, 113, 133, 0.12);
            transform: scale(1.1);
        }

        /* === Empty state === */
        .empty-state {
            text-align: center;
            padding: 40px 0;
            color: var(--text-muted);
            animation: fade-in 0.5s ease;
        }

        @keyframes fade-in {
            from {
                opacity: 0;
                transform: scale(0.95);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .empty-state .empty-icon {
            font-size: 3rem;
            margin-bottom: 12px;
            opacity: 0.6;
            animation: empty-bounce 3s ease-in-out infinite;
        }

        @keyframes empty-bounce {

            0%,
            100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-8px);
            }
        }

        .empty-state p {
            font-size: 0.92rem;
            font-weight: 300;
        }

        /* === Inline edit === */
        .inline-edit {
            flex: 1;
            background: rgba(168, 85, 247, 0.1);
            border: 1.5px solid var(--purple-vivid);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 1rem;
            font-family: 'Outfit', sans-serif;
            padding: 4px 10px;
            outline: none;
            box-shadow: 0 0 0 4px rgba(168, 85, 247, 0.15);
            animation: focus-ring 0.3s ease;
        }

        @keyframes focus-ring {
            from {
                box-shadow: 0 0 0 0 rgba(168, 85, 247, 0);
            }

            to {
                box-shadow: 0 0 0 4px rgba(168, 85, 247, 0.15);
            }
        }

        /* === Footer === */
        .footer {
            text-align: center;
            margin-top: 24px;
            font-size: 0.78rem;
            color: var(--text-muted);
            letter-spacing: 0.04em;
            font-weight: 300;
            opacity: 0.7;
        }

        /* === Responsive === */
        @media (max-width: 600px) {
            .app {
                max-width: 100%;
            }

            .card {
                padding: 24px 18px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .stat-value {
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body>
    <!-- Background mesh -->
    <div class="bg-mesh">
        <div class="orb"></div>
        <div class="orb"></div>
        <div class="orb"></div>
        <div class="orb"></div>
    </div>

    <div class="app">
        <!-- Header -->
        <div class="header">
            <div class="logo">
                <i class="bi bi-check2-all" style="color:white; font-size:1.8rem;"></i>
            </div>
            <h1>TODO List</h1>
            <p>Stay focused. Get things done.</p>
        </div>

        <!-- Card -->
        <div class="card">
            <!-- Stats -->
            <div class="stats-bar">
                <div class="stat">
                    <div class="stat-value" id="stat-total">0</div>
                    <div class="stat-label">Total</div>
                </div>
                <div class="stat">
                    <div class="stat-value" id="stat-done">0</div>
                    <div class="stat-label">Done</div>
                </div>
                <div class="stat">
                    <div class="stat-value" id="stat-left">0</div>
                    <div class="stat-label">Remaining</div>
                </div>
            </div>

            <!-- Progress -->
            <div class="progress-wrap">
                <div class="progress-label">
                    <span>Progress</span>
                    <span id="progress-pct">0%</span>
                </div>
                <div class="progress-track">
                    <div class="progress-fill" id="progress-fill" style="width:0%"></div>
                </div>
            </div>

            <!-- Add task form -->
            <form id="task-form">
                <div class="input-row">
                    <div class="input-wrap">
                        <input type="text" id="new-task" placeholder="What needs to be done?" required
                            autocomplete="off" />
                        <i class="bi bi-plus-circle input-icon"></i>
                    </div>
                    <button type="submit" class="btn-add">
                        <span><i class="bi bi-plus-lg"></i> Add</span>
                    </button>
                </div>
            </form>

            <!-- Filters -->
            <div class="filter-tabs">
                <button class="filter-tab active" data-filter="all">
                    <i class="bi bi-list-ul"></i> All
                </button>
                <button class="filter-tab" data-filter="active">
                    <i class="bi bi-circle"></i> Active
                </button>
                <button class="filter-tab" data-filter="completed">
                    <i class="bi bi-check-circle"></i> Done
                </button>
            </div>

            <!-- Task list -->
            <ul id="tasks"></ul>
        </div>

        <div class="footer">
            <i class="bi bi-lightning-charge-fill"></i> Tasks synced to server
        </div>
    </div>

    <script>
        // --- API base URL ---
        const path = location.pathname.replace(/\/+$/, '').replace(/\/index\.jsp$/i, '');
        const apiUrl = path + '/api/tasks';

        let allTasks = [];
        let currentFilter = 'all';

        // --- Fetch & Render ---
        async function loadTasks() {
            try {
                const res = await fetch(apiUrl, { cache: 'no-store' });
                allTasks = await res.json();
            } catch (e) {
                allTasks = [];
            }
            renderTasks();
            updateStats();
        }

        function renderTasks() {
            const list = document.getElementById('tasks');
            list.innerHTML = '';

            const filtered = allTasks.filter(t => {
                if (currentFilter === 'active') return !t.completed;
                if (currentFilter === 'completed') return t.completed;
                return true;
            });

            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'empty-state';
                let icon, msg;
                if (currentFilter === 'completed') {
                    icon = '🏁'; msg = 'No completed tasks yet.';
                } else if (currentFilter === 'active') {
                    icon = '🎉'; msg = 'All caught up! Great work.';
                } else {
                    icon = '📝'; msg = 'No tasks yet — add one above!';
                }
                empty.innerHTML = '<div class="empty-icon">' + icon + '</div><p>' + msg + '</p>';
                list.appendChild(empty);
                return;
            }

            filtered.forEach((task, i) => {
                const li = document.createElement('li');
                li.style.animationDelay = (i * 0.05) + 's';
                if (task.completed) li.classList.add('completed');

                // Custom checkbox
                const checkWrap = document.createElement('label');
                checkWrap.className = 'custom-checkbox';
                const chk = document.createElement('input');
                chk.type = 'checkbox';
                chk.checked = task.completed;
                chk.addEventListener('change', () => toggleTask(task));
                const checkmark = document.createElement('span');
                checkmark.className = 'checkmark';
                checkWrap.appendChild(chk);
                checkWrap.appendChild(checkmark);
                li.appendChild(checkWrap);

                // Title
                const span = document.createElement('span');
                span.textContent = task.title;
                span.className = 'title';
                li.appendChild(span);

                // Edit button
                const editBtn = document.createElement('button');
                editBtn.className = 'icon-btn edit';
                editBtn.title = 'Edit';
                editBtn.innerHTML = '<i class="bi bi-pencil-square"></i>';
                editBtn.addEventListener('click', () => editTask(task, span, li, editBtn));
                li.appendChild(editBtn);

                // Delete button
                const del = document.createElement('button');
                del.className = 'icon-btn delete';
                del.title = 'Delete';
                del.innerHTML = '<i class="bi bi-trash3-fill"></i>';
                del.addEventListener('click', () => deleteTask(task.id, li));
                li.appendChild(del);

                list.appendChild(li);
            });
        }

        function updateStats() {
            const total = allTasks.length;
            const done = allTasks.filter(t => t.completed).length;
            const left = total - done;
            const pct = total > 0 ? Math.round((done / total) * 100) : 0;

            animateValue('stat-total', total);
            animateValue('stat-done', done);
            animateValue('stat-left', left);
            document.getElementById('progress-pct').textContent = pct + '%';
            document.getElementById('progress-fill').style.width = pct + '%';
        }

        function animateValue(id, target) {
            const el = document.getElementById(id);
            const current = parseInt(el.textContent) || 0;
            if (current === target) return;
            const step = target > current ? 1 : -1;
            let val = current;
            const interval = setInterval(() => {
                val += step;
                el.textContent = val;
                if (val === target) clearInterval(interval);
            }, 60);
        }

        // --- Inline edit ---
        function editTask(task, span, li, editBtn) {
            const input = document.createElement('input');
            input.type = 'text';
            input.className = 'inline-edit';
            input.value = task.title;
            li.replaceChild(input, span);
            input.focus();
            input.select();

            editBtn.innerHTML = '<i class="bi bi-check-lg"></i>';
            editBtn.title = 'Save';

            const save = () => {
                const val = input.value.trim();
                if (val && val !== task.title) {
                    task.title = val;
                    updateTask(task);
                } else {
                    span.textContent = task.title;
                    li.replaceChild(span, input);
                    editBtn.innerHTML = '<i class="bi bi-pencil-square"></i>';
                    editBtn.title = 'Edit';
                    editBtn.onclick = () => editTask(task, span, li, editBtn);
                }
            };

            editBtn.onclick = save;
            input.addEventListener('keydown', e => {
                if (e.key === 'Enter') save();
                if (e.key === 'Escape') {
                    span.textContent = task.title;
                    li.replaceChild(span, input);
                    editBtn.innerHTML = '<i class="bi bi-pencil-square"></i>';
                    editBtn.title = 'Edit';
                    editBtn.onclick = () => editTask(task, span, li, editBtn);
                }
            });
            input.addEventListener('blur', save);
        }

        // --- CRUD ---
        async function addTask(title) {
            await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ title, completed: false })
            });
            loadTasks();
        }

        async function deleteTask(id, li) {
            li.style.opacity = '0';
            li.style.transform = 'translateX(30px) scale(0.95)';
            li.style.filter = 'blur(4px)';
            li.style.transition = 'all 0.3s ease';
            await new Promise(r => setTimeout(r, 280));
            const res = await fetch(apiUrl + '/' + id, { method: 'DELETE' });
            if (!res.ok) { console.error('delete failed', res.status); }
            loadTasks();
        }

        async function toggleTask(task) {
            task.completed = !task.completed;
            await fetch(apiUrl + '/' + task.id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(task)
            });
            loadTasks();
        }

        async function updateTask(task) {
            await fetch(apiUrl + '/' + task.id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(task)
            });
            loadTasks();
        }

        // --- Form submit ---
        document.getElementById('task-form').addEventListener('submit', e => {
            e.preventDefault();
            const inp = document.getElementById('new-task');
            if (inp.value.trim()) {
                addTask(inp.value.trim());
                inp.value = '';
            }
        });

        // --- Filter tabs ---
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.addEventListener('click', () => {
                document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                currentFilter = tab.dataset.filter;
                renderTasks();
            });
        });

        // --- Init ---
        loadTasks();
    </script>
</body>

</html>