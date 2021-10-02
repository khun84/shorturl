Rails.application.routes.draw do
  # devise_for :users
  # Forregistrations_controller.rb details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, skip: :registrations, path: '',
             path_names: {sign_in: 'login',
                          sign_out: 'logout',
                          sign_up:'register',
             },
             controllers: {registrations: 'registrations'}

  # set the prefix of the path so that we can rename the path helper method
  ## BECAREFUL, USE :user insteand :users
  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :login
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', as: :logout
    # create user has the same path name as
    get 'register', to: 'registrations#new', as: :register
    post 'register', to: 'registrations#create'
    # get '/', to: 'dashboard#index'

  end
end
