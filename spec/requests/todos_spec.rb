require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe 'GET /todos' do
    before { get '/todos' }

    it 'return todos' do
      expect(json).to_not be_empty
      expect(json.size).to eq(10)
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when the record exists' do
      it 'return the todo' do
        expect(json).to_not be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'return status 200' do
        expect(response).to have_http_status (200)
      end
    end

    context 'when the record not exist' do
      let(:todo_id) { 100 }

      it 'return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1'} }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }

      it 'create a todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'return status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request invalid' do
      before { post '/todos', params: { title: 'Foobar' } }

      it 'return status 500' do
        expect(response).to have_http_status(500)
      end

      it 'return a validation failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) { {title: 'Shopping'} }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }

      it 'update the record' do
        expect(response.body).to be_empty
      end

      it 'return status 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    it 'return status 204' do
      expect(response).to have_http_status(204)
    end
  end
end
