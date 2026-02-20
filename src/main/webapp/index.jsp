<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="coffeeicon.ico" type="image/x-icon">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World</title>
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
        
        .hello-box {
            background: linear-gradient(135deg, #0096ff, #0070cc);
            color: white;
            padding: 60px 80px;
            border-radius: 20px;
            font-size: 48px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 0 40px rgba(0, 150, 255, 0.8),
                        0 0 60px rgba(157, 78, 221, 0.6),
                        0 0 80px rgba(157, 78, 221, 0.4),
                        0 20px 40px rgba(0, 0, 0, 0.3);
            animation: shimmer 2s ease-in-out infinite;
        }
        
        @keyframes shimmer {
            0%, 100% {
                box-shadow: 0 0 40px rgba(0, 150, 255, 0.8),
                            0 0 60px rgba(157, 78, 221, 0.6),
                            0 0 80px rgba(157, 78, 221, 0.4),
                            0 20px 40px rgba(0, 0, 0, 0.3);
            }
            50% {
                box-shadow: 0 0 50px rgba(0, 150, 255, 1),
                            0 0 80px rgba(157, 78, 221, 0.8),
                            0 0 100px rgba(157, 78, 221, 0.6),
                            0 20px 40px rgba(0, 0, 0, 0.3);
            }
        }
    </style>
</head>
<body>
    <div class="hello-box">Hello World</div>
</body>
</html>
