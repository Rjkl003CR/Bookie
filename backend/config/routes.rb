Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Auth
      devise_for :users,
        path: "",
        path_names: {
          sign_in: "login",
          sign_out: "logout",
          registration: "signup"
        },
        controllers: {
          sessions: "api/v1/auth/sessions",
          registrations: "api/v1/auth/registrations"
        }

      # Passenger routes
      resources :routes, only: [:index, :show]
      resources :schedules, only: [:index, :show]
      resources :bookings, only: [:index, :show, :create, :destroy]
      resources :seats, only: [:index]

      # Bus Owner routes
      namespace :owner do
        resources :buses
        resources :schedules
        resources :fares
        resources :analytics, only: [:index]
      end

      # Admin routes
      namespace :admin do
        resources :users, only: [:index, :show, :update, :destroy]
        resources :operators, only: [:index, :show, :update]
        resources :settings
        resources :audit_logs, only: [:index]
      end

      # AI assistant
      post "chat", to: "chat#create"
    end
  end
end
