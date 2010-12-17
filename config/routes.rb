PivotalPlanningPoker::Application.routes.draw do
  root :to => 'home#index'

  resources :user_sessions, :only => [:create, :new, :destroy]

  resources :projects, :only => [:index, :show] do
    resources :stories, :only => [ :show, :update ] do
      resources :estimates, :only => [ :create, :index ] do
        put :reveal, :on => :collection
      end
    end
  end
end
