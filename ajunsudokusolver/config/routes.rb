Rails.application.routes.draw do
  root to: 'sudoku#index'
  resources :sudoku do 
  end

  get :easy, to: 'sudoku#easy'
  get :medium, to: 'sudoku#medium'
  get :hard, to: 'sudoku#hard'
  get :evil, to: 'sudoku#evil'
end
