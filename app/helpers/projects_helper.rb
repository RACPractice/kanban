module ProjectsHelper
  def thumb_avatar_src(membership)
    if membership.user.avatar.present?
      membership.user.avatar.url(:thumb)
    else
      '/assets/default_user_icon_128.png'
    end
  end
end
