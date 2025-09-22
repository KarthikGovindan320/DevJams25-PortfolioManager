// verify_otp.php
<?php
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

$conn = new mysqli('iunderstandit.in', 'karthik', 'admin_pass_11_16264', 'karthik_PortfolioManager');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$email = $data['email'];
$otp = $data['otp'];

$stmt = $conn->prepare("SELECT u.id FROM users u JOIN otps o ON u.id = o.user_id WHERE u.email = ? AND o.otp = ? AND o.created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)");
$stmt->bind_param("ss", $email, $otp);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid or expired OTP']);
}

$stmt->close();
$conn->close();
?>