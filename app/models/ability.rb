class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)

    can :thank_you, Report

    case user.role.name
    when "admin"
      can :manage, :all
    when "validator"
      can :read, Report
      can :validate, Report
      can :lock, Report
      can :thank_you, Validation
    when "provider"
      can :create, Report
      can :read, Report, user: {agency_id: user.agency.id}
      can :update, Report, user: user
      can :destroy, Report, user: user
      can :upload, Report
    else
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
