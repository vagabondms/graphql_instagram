String GET_POSTS = """
  query getPosts(\$pagingInput: PostPagingInput!) {
     getPosts(postPaging: \$pagingInput) {
        __typename
        id
        user {
          nickname
          profileImage
        }
        isMine
        isLike
        likeCount
        likeMembers () {
          id
          profileImage
          nickname
        }
        medias {
          url
        }
        description
        modifiedAt
    }
  }
""";
