class LoginService
  def initialize
    @users = {
      "admin" => "password123",
      "user1" => "passw0rd",
      "guest" => "guest123"
    }
  end

  def login(username, password)
    if @users[username] && @users[username] == password
      return true
    else
      return false
    end
  end

  def require_admin(user)
    if user == "admin"
      return true
    else
      raise "Access denied: Admins only"
    end
  end

  def user_exists(username)
    if @users.key?(username)
      return true
    else
      return false
    end
  end

  def password_strength(password)
    if password.length >= 8
      return "strong"
    else
      return "weak"
    end
  end

  
end