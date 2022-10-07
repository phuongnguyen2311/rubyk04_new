function UserShow(options) {
  var module = this;
  var defaults = {
    template: {},
    api: {
      unfollow: '/api/v1/relationships/',
      follow: '/api/v1/relationships'
    },
    data: {
      token: Cookies.get('api_token')
    }
  };
  module.settings = $.extend({}, defaults, options);

  module.unfollow = function () {
    $(document).on("click", ".btnunfollow", function () {
      var followed_id = $(this).data('followed-id');
      $.ajax({
        url: module.settings.api.unfollow + followed_id,
        headers: {
          'api_token': module.settings.data.token
        },
        type: 'delete',
        dataType: 'json',
        success: function (data) {
          if (data.code == 200) {
            $.notify(data.message, 'success');
            $('#follow_form').html('<input type="button" name="commit" value="Follow" class="btn btn-primary btnfollow" data-disable-with="Follow" data-followed-id="' + followed_id + '">');
          } else {
            $.notify(data.message, "error");
          }
        },
        error: function () { }
      });
    });
  };

  module.follow = function () {
    $(document).on("click", ".btnfollow", function () {
      console.log(222222222222)
      var followed_id = $(this).data('followed-id');
      $.ajax({
        url: module.settings.api.follow,
        headers: {
          'api_token': module.settings.data.token
        },
        type: 'POST',
        data: { followed_id: followed_id },
        dataType: 'json',
        success: function (data) {
          if (data.code == 200) {
            $.notify(data.message, 'success');
            $('#follow_form').html('<input type="button" name="commit" value="Unfollow" class="btn btnunfollow" data-disable-with="Unfollow" data-followed-id="' + followed_id + '">');
          } else {
            $.notify(data.message, "error");
          }
        },
        error: function () { }
      });
    });
  };


  module.init = function () {
    module.unfollow();
    module.follow();
  };
}

$(document).ready(function () {
  user = new UserShow;
  user.init();
});