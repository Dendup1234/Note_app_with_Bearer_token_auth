Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  namespace :api do
    namespace :v1 do
      # Company routes
      get "recruiter/company", to: "companies#show"
      post "recruiter/company", to: "companies#create"
      patch "recruiter/company", to: "companies#update"
      # Recruiter routes
      get "recruiter/profile",to: "recruiter_profiles#show"
      patch "recruiter/profile", to: "recruiter_profiles#update"
      get "recruiter/dashboard", to: "recruiter_dashboard#index"
      #intership routes for recruiter
      get "recruiter/internships", to: "recruiter_internships#index"
      post "recruiter/internships", to: "recruiter_internships#create"
      get "recruiter/internships/:id", to: "recruiter_internships#show"
      patch "recruiter/internships/:id", to: "recruiter_internships#update"
      patch "recruiter/internships/:id/close", to: "recruiter_internships#close"
      delete "recruiter/internships/:id", to: "recruiter_internships#destroy"
      # Student routes
      get "student/profile" ,to: "student_profiles#show"
      patch "student/profile", to: "student_profiles#update"
      get "student/dashboard", to: "student_dashboard#index"
      # Authentication routes
      post "register", to: "auth#register"
      post "login", to: "auth#login"
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
