class Ability

  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: nil)
    if user.admin?
      can :manage, :all
      cannot :destroy, User, id: user.id
    elsif user.user?
      can :update, User, id: user.id
      can :manage, Task, user_id: user.id
      can :read, Attachment, task_id: user.task_ids
    end
  end

end
