// reset_password.php
<?php
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

$conn = new mysqli('iunderstandit.in', 'karthik', 'admin_pass_11_16264', 'karthik_PortfolioManager');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$email = $data['email'];
$otp = $data['otp'];
$new_password = md5($data['new_password']);  // Use better hashing

$stmt_verify = $conn->prepare("SELECT u.id FROM users u JOIN otps o ON u.id = o.user_id WHERE u.email = ? AND o.otp = ? AND o.created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)");
$stmt_verify->bind_param("ss", $email, $otp);
$stmt_verify->execute();
$result = $stmt_verify->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    $user_id = $user['id'];

    $stmt_update = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
    $stmt_update->bind_param("si", $new_password, $user_id);
    $stmt_update->execute();

    // Delete used OTP
    $stmt_delete = $conn->prepare("DELETE FROM otps WHERE user_id = ?");
    $stmt_delete->bind_param("i", $user_id);
    $stmt_delete->execute();

    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid or expired OTP']);
}

$stmt_verify->close();
$conn->close();
?>