String GET_POSTS = """
  query getPosts(\$lastId: Int!,\$size: Int!) {
     getPosts(postPaging: {
    	  lastId: \$lastId,
   		  size:\$size,
     }) {
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
        lastModifiedAt
    }
  }
""";
