import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey quản lý trạng thái của Form (Lab 7.1)
  final _formKey = GlobalKey<FormState>();

  // Controllers để lấy giá trị text từ các ô nhập liệu
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // FocusNodes quản lý di chuyển con trỏ và bàn phím (Lab 7.3)
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // Biến trạng thái UI
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isCheckingEmail = false; // Trạng thái kiểm tra Async (Lab 7.4)
  String _passwordStrength = '';

  @override
  void dispose() {
    // Giải phóng bộ nhớ của các controller và focus node khi hủy widget
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // --- Các hàm Validation tách biệt (Lab 7.2) ---
  
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    // Kiểm tra định dạng email cơ bản có chứa @ và . (Lab 7.1 / 7.2)
    if (!value.contains('@') || !value.contains('.')) {
      return 'Định dạng email không hợp lệ (Phải có @ và .)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    // Kiểm tra phải chứa ít nhất 1 chữ số (Lab 7.2)
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ số';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận lại mật khẩu';
    }
    // So sánh với giá trị của ô mật khẩu (Lab 7.2)
    if (value != _passwordController.text) {
      return 'Mật khẩu xác nhận không trùng khớp';
    }
    return null;
  }

  // Hàm cập nhật nhanh độ mạnh của mật khẩu khi người dùng gõ (Bonus)
  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() => _passwordStrength = '');
      return;
    }
    if (value.length < 6) {
      setState(() => _passwordStrength = 'Yếu');
    } else if (value.length >= 8 && RegExp(r'[0-9]').hasMatch(value) && RegExp(r'[A-Z]').hasMatch(value)) {
      setState(() => _passwordStrength = 'Mạnh');
    } else {
      setState(() => _passwordStrength = 'Trung bình');
    }
  }

  // --- Hàm xử lý Submit Form (Kết hợp Sync & Async Validation - Lab 7.4) ---
  Future<void> _submitForm() async {
    // 1. Kiểm tra validation cục bộ (Synchronous)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Kiểm tra điều khoản bổ sung (Bonus)
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn phải đồng ý với Điều khoản & Điều kiện sử dụng'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 3. Ẩn bàn phím sau khi nhấn submit thành công bước đầu
    FocusScope.of(context).unfocus();

    // 4. Giả lập gọi API kiểm tra trùng email (Asynchronous - Lab 7.4)
    setState(() {
      _isCheckingEmail = true;
    });

    // Giả lập độ trễ server 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // Luật giả định: Nếu email bắt đầu bằng từ "taken" thì báo lỗi (Lab 7.4)
    if (_emailController.text.trim().toLowerCase().startsWith('taken')) {
      setState(() {
        _isCheckingEmail = false;
      });
      
      // Hiển thị thông báo lỗi trùng email (Lab 7.4)
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lỗi đăng ký'),
            content: Text('Email "${_emailController.text}" đã có người sử dụng. Vui lòng chọn email khác.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
      return; 
    }

    // 5. Hoàn tất quá trình và báo thành công (Lab 7.1 / 7.4)
    setState(() {
      _isCheckingEmail = false;
    });



    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Đăng ký tài khoản thành công cho ${_nameController.text}!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Reset form sau khi đăng ký thành công
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _acceptTerms = false;
        _passwordStrength = '';
      });
    }
  }

  // Lấy màu sắc tương ứng cho độ mạnh mật khẩu (Bonus)
  Color _getStrengthColor() {
    if (_passwordStrength == 'Yếu') return Colors.red;
    if (_passwordStrength == 'Trung bình') return Colors.orange;
    if (_passwordStrength == 'Mạnh') return Colors.green;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bấm ra ngoài vùng nhập liệu sẽ tự động đóng bàn phím (Lab 7.3)
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký tài khoản (Lab 7)'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade100,
        ),
        // Dùng SingleChildScrollView tránh lỗi tràn khung (overflow) khi mở bàn phím ảo (Lab 7.3)
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            // Tự động validate khi người dùng có tương tác với trường nhập liệu (Lab 7.2)
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // --- Trường Họ và Tên ---
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên *',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next, // Nút 'Tiếp tục' trên bàn phím (Lab 7.3)
                  validator: _validateName,
                  // Khi ấn nút Next trên bàn phím sẽ nhảy sang ô Email (Lab 7.3)
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                ),
                const SizedBox(height: 16),

                // --- Trường Email ---
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    helperText: 'Thử nhập email bắt đầu bằng "taken..." để test lỗi API',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  // Nhảy sang ô Password (Lab 7.3)
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 16),

                // --- Trường Mật khẩu ---
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu *',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    // Nút bật/tắt hiển thị mật khẩu (Bonus)
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  onChanged: _checkPasswordStrength,
                  // Nhảy sang ô Xác nhận mật khẩu (Lab 7.3)
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                ),
                
                // Hiển thị độ mạnh yếu mật khẩu nếu có (Bonus)
                if (_passwordStrength.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('Độ mạnh mật khẩu: ', style: const TextStyle(fontSize: 13)),
                      Text(
                        _passwordStrength,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _getStrengthColor()),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // --- Trường Xác nhận mật khẩu ---
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu *',
                    prefixIcon: const Icon(Icons.lock_clock),
                    border: const OutlineInputBorder(),
                    // Nút bật/tắt hiển thị xác nhận mật khẩu (Bonus)
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.done, // Nút 'Hoàn tất' trên bàn phím (Lab 7.3)
                  validator: _validateConfirmPassword,
                  // Khi ấn Done trên bàn phím sẽ kích hoạt submit form luôn (Lab 7.3)
                  onFieldSubmitted: (_) => _submitForm(),
                ),
                const SizedBox(height: 12),

                // --- Checkbox Điều khoản & Điều kiện (Bonus) ---
                CheckboxListTile(
                  title: const Text(
                    'Tôi đồng ý với Điều khoản dịch vụ và Chính sách bảo mật.',
                    style: TextStyle(fontSize: 13),
                  ),
                  value: _acceptTerms,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _acceptTerms = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // --- Nút Đăng ký (Submit Button) ---
                ElevatedButton(
                  onPressed: _isCheckingEmail ? null : _submitForm, // Vô hiệu hóa nút khi đang gọi API kiểm tra (Lab 7.4)
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isCheckingEmail
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          // Vòng xoay tải dữ liệu thay cho chữ khi đang check Async (Lab 7.4)
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Đăng ký tài khoản',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}