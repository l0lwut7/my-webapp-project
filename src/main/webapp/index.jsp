<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <link rel="icon" href="coffeeicon.ico" type="image/x-icon">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            width: 100%;
            height: 100vh;
            background: radial-gradient(circle at 50% 50%, #9d4edd, #5a189a, #240046);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            width: 320px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
        }

        h1 {
            text-align: center;
            margin-bottom: 10px;
        }

        form {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
        }

        input[type=text] {
            flex: 1;
            padding: 4px 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 4px 8px;
            border: none;
            background: #007bff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

        ul#tasks {
            list-style: none;
        }

        ul#tasks li {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 0;
        }

        ul#tasks li.completed span.title {
            text-decoration: line-through;
            color: #777;
        }

        ul#tasks li button.icon-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #666;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>TODO List</h1>
        <form id="task-form">
            <input type="text" id="new-task" placeholder="New task title" required />
            <button type="submit">Add</button>
        </form>
        <ul id="tasks"></ul>
    </div>

    <script>
        // compute base path robustly: strip trailing slash and /index.jsp if present
        const path = location.pathname.replace(/\/+$/, '').replace(/\/index\.jsp$/i, '');
        const apiUrl = path + '/api/tasks';

        async function loadTasks() {
            const res = await fetch(apiUrl, { cache: 'no-store' });
            const tasks = await res.json();
            const list = document.getElementById('tasks');
            list.innerHTML = '';
            tasks.forEach(task => {
                const li = document.createElement('li');
                if (task.completed) li.classList.add('completed');

                const chk = document.createElement('input');
                chk.type = 'checkbox';
                chk.checked = task.completed;
                chk.addEventListener('change', () => toggleTask(task));
                li.appendChild(chk);

                const span = document.createElement('span');
                span.textContent = task.title;
                span.className = 'title';
                li.appendChild(span);

                const editBtn = document.createElement('button');
                editBtn.className = 'icon-btn';
                editBtn.innerHTML = '<i class="bi bi-pencil"></i>';
                editBtn.addEventListener('click', () => editTask(task, span));
                li.appendChild(editBtn);

                const del = document.createElement('button');
                del.className = 'icon-btn';
                del.innerHTML = '<i class="bi bi-trash"></i>';
                del.addEventListener('click', () => deleteTask(task.id));
                li.appendChild(del);

                list.appendChild(li);
            });
        }

        function editTask(task, span) {
            const newTitle = prompt('New title', task.title);
            if (newTitle && newTitle.trim()) {
                task.title = newTitle.trim();
                updateTask(task);
            }
        }

        async function addTask(title) {
            await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ title, completed: false })
            });
            loadTasks();
        }

        async function deleteTask(id) {
            const res = await fetch(apiUrl + '/' + id, { method: 'DELETE' });
            if (!res.ok) {
                console.error('delete failed', res.status);
                return;
            }
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

        document.getElementById('task-form').addEventListener('submit', e => {
            e.preventDefault();
            const inp = document.getElementById('new-task');
            if (inp.value.trim()) {
                addTask(inp.value.trim());
                inp.value = '';
            }
        });

        loadTasks();
    </script>
</body>

</html>