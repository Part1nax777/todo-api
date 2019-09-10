require 'rails_helper'

RSpec.describe 'Items API' do
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id ) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo exists' do
      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return all todo items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when todo not exist' do
      let(:todo_id) { 0 }

      it 'return status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{id}" }

    context 'when todo items exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when todo item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'return not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Hello word', done: false } }

    context 'when request attributes is valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes }

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request attributes is invalid' do
      before { post "/todos/#{todo_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' } }

    before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

    context 'when items exists' do
      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end

      it 'update the item' do
        update_item = Item.find(id)
        expect(update_item.name).to match(/Mozart/)
      end
    end

    context 'when item not exist' do
      let(:id) { 0 }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}" }

    it 'return status 204' do
      expect(response).to have_http_status(204)
    end
  end
end
