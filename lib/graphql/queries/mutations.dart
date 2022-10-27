const String LOG_IN = """
  mutation login(\$email: String!, \$password: String! ) {
    login(email:\$email, password :\$password) {
      accessToken
      refreshToken
    }
  }
""";

const String REISSUE = """
  mutation getATokenByRToken {
    getATokenByRToken
  }
""";
