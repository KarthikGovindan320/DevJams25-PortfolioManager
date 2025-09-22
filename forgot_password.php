// forgot_password.php
<?php
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

$conn = new mysqli('iunderstandit.in', 'karthik', 'admin_pass_11_16264', 'karthik_PortfolioManager');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$email = $data['email'];

$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    $user_id = $user['id'];
    $otp = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);

    $stmt_otp = $conn->prepare("INSERT INTO otps (user_id, otp) VALUES (?, ?)");
    $stmt_otp->bind_param("is", $user_id, $otp);
    $stmt_otp->execute();

    // Send email (use mail() or PHPMailer)
    $to = $email;
    $subject = "Password Reset OTP";
    $message = "Your OTP is: $otp";
    $headers = "From: no-reply@iunderstandit.in";
    mail($to, $subject, $message, $headers);  // Configure mail server

    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Email not found']);
}

$stmt->close();
$conn->close();
?>