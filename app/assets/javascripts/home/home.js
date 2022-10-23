function HomePage(options) {
  var module = this;
  var defaults = {
    template: {
      new_post: $("#new_post"),
      new_comment: $("#new_comment"),
    },
    api: {
      deletePost: "/api/v1/microposts/",
      createPost: "/api/v1/microposts",
      createComment: "/api/v1/comments",
      deleteComment: "/api/v1/comments/",
    },
    data: {
      token: Cookies.get('api_token')
    }
  };
  module.settings = $.extend({}, defaults, options);

  module.showPost = function () {
    $(document).on("click", "#new_wall_post", function () {
      $('#myModal').modal({
        show: 'true'
      });
    });
  };

  module.createPost = function () {
    $(document).on("click", ".btn-post", function () {
      var content = $('#micropost_content').val();
      var image = $('#micropost_image')[0].files[0];
      var formData = new FormData();
      formData.append('content', content);
      formData.append('image', image);
      $.ajax({
        url: module.settings.api.createPost,
        headers: {
          'Api-Token': module.settings.data.token
        },
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (res) {
          if (res.code == 200) {
            $.notify(res.message, 'success');
            $('#myModal').modal('hide');
            $('#micropost_content').val('');
            $('#micropost_image').val('');
            var new_post_template = Handlebars.compile(module.settings.template.new_post.html());
            $(".microposts").prepend(new_post_template({ user: res.data.user, micropost: res.data.micropost }));
          } else {
            $.notify(res.message, "error");
          }
        },
        error: function () { }
      });
    });
  }

  module.deletePost = function () {
    $(document).on("click", ".btn-delete", function () {
      el = $(this);
      var data = $(el).closest('li').attr('id')
      var post_id = data.split('-')[1];
      $.ajax({
        url: module.settings.api.deletePost + post_id,
        headers: {
          'api_token': module.settings.data.token
        },
        type: 'DELETE',
        dataType: 'json',
        success: function (data) {
          if (data.code == 200) {
            $.notify(data.message, 'success');
            $(el).closest('li').remove();
          } else {
            $.notify(data.message, "error");
          }
        },
        error: function () { }
      });
    });
  };

  module.createComment = function () {
    $(document).on('keypress', function (e) {
      if (e.which === 13 && e.target.className.indexOf('in-comment') >= 0) {
        var content = e.target.value;
        var micropost_id = $(e.target.closest('li')).attr('id').split('-')[1];
        $.ajax({
          url: module.settings.api.createComment,
          headers: {
            'Api-Token': module.settings.data.token
          },
          type: 'POST',
          data: { content: content, micropost_id: micropost_id },
          success: function (res) {
            if (res.code == 200) {
              $.notify(res.message, 'success');
              e.target.value = '';
              var new_comment = Handlebars.compile(module.settings.template.new_comment.html());
              var el = $(e.target.closest('li'))
              $(el).find(".list-comment").append(new_comment({ user: res.data.user, comment: res.data.comment }));
            } else {
              $.notify(res.message, "error");
            }
          },
          error: function () { }
        });
      }
    });
  }

  module.deleteComment = function () {
    $(document).on("click", ".btn-del-comment", function () {
      var comment_id = $(this).prev().attr('data-commment-id');
      var el = $(this)
      $.ajax({
        url: module.settings.api.deleteComment + comment_id,
        headers: {
          'api_token': module.settings.data.token
        },
        type: 'DELETE',
        dataType: 'json',
        success: function (data) {
          if (data.code == 200) {
            $.notify(data.message, 'success');
            $(el).closest('.list-cmt-span').remove();
          } else {
            $.notify(data.message, "error");
          }
        },
        error: function () { }
      });
    });
  };
  module.init = function () {
    module.showPost();
    module.deletePost();
    module.createPost();
    module.createComment();
    module.deleteComment();
  };
}

$(document).ready(function () {
  homepage = new HomePage;
  homepage.init();
});