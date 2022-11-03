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

const String CREATE_LIKE = """
  mutation createLike(\$likeInput: LikeInput!) {
    createLike(likeInput: \$likeInput)
  }
""";

const String DELETE_LIKE = """
  mutation deleteLike(\$likeInput: LikeInput!) {
    deleteLike(likeInput : \$likeInput)
  }
""";
