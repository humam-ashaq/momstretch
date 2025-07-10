class LoginHistory {
  final String timestamp;
  final String device;
  final String ip;

  LoginHistory({
    required this.timestamp,
    required this.device,
    required this.ip,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      timestamp: json['timestamp'],
      device: json['device'] ?? 'Tidak diketahui',
      ip: json['ip'] ?? 'Tidak diketahui',
    );
  }
}