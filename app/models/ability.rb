class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    
    unless user.nil?
      can :create, Event
      can :edit, Event, :creator => user
      
      if user.admin?
        can :manage, Event
      end
    end
  end

end
