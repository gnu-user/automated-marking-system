##############################################################################
#
# Automated Marking System (AMS)
# 
# A scalable automated marking system that provides automated marking, quality
# feedback, and cheating detection all in one easy to use solution.
#
#
# Copyright (C) 2014, Joseph Heron, Jonathan Gillett, Daniel Smullen, 
# and Khalil Fazal
# All rights reserved.
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
AutomatedMarkingSystem::Application.routes.draw do
  # Uncomment when enabling HTTPS
  # scope constraints: {protocol: 'https'}
  #resources :phone_book
  get 'login' => 'login#index'
  get 'login/new' => 'login#new'
  post 'login/create' => 'login#create'
  get 'admin/login' => 'admin_login#index'
  post "sessions/new" => 'sessions#create'
  post "admin/sessions/new" => 'admin_sessions#create'
  get "admin/log_out" => 'admin_sessions#destroy'
  get "log_out" => "sessions#destroy", :as => "log_out"
  # Create a new admin
  get 'admin/login/new' => 'admin_login#new'
  post 'admin/login/create' => 'admin_login#create'
  #resources :student
  root to: redirect('/login')
  #root 'student#index'
  get 'student' => 'student#index', :as => :student
  get 'student/:file' => 'student#show'
  get 'student/assignment/:id' => 'student#assignment', as: 'student_assignment'
  post 'student/assignment/:id' => 'student#submission'
  get 'student/grades/:id' => 'student#grading'
  post 'student/test/:id' => 'student#test'
  post 'student/submit/:id' => 'student#submit'
  get 'admin' => 'admin#index'
  get 'admin/new' => 'admin#new'
  get 'admin/grades/:id' => 'admin#grading'
  get 'admin/grades/:id/cheating' => 'admin#cheat'
  get 'admin/assignment/:id' => 'admin#show'
  post 'admin/create' => 'admin#create'
  post 'admin/upload' => 'admin#upload'
  post 'admin/submit' => 'admin#submit'

  #get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  #get "/500", :to => "errors#internal_error"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
