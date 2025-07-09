//Modelo de registro
class UserRegister {
  final String name;
  final String email;
  final String password;
 
  UserRegister({
    required this.name, 
    required this.email,
    required this.password });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        
      };
}

//Modelo de login
class UserLogin {
  final String email;
  final String password;
 
  UserLogin({
    required this.email,
    required this.password });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,  
      };
}


