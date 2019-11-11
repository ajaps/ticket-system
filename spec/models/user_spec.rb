require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:admin) { create(:user, :admin) }
  let!(:agent) { create(:user, :agent) }
  let!(:customer) { create(:user) }

  describe 'validations' do
    it 'is invalid without an email' do
      user = User.new(name: 'Ajaps', password: 'qwerty')
      expect { user.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank, Email is invalid")
    end

    it 'is invalid if email is not unique' do
      create(:user, email: 'franklin@gmail.com', name: 'Ajaps', password: 'qwerty')
      user2 = build(:user, email: 'franklin@gmail.com', name: 'Franklin', password: 'poiuyt')

      expect { user2.save! }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email has already been taken')
    end

    it 'is invalid without a name' do
      user = User.new(email: 'franklin@gmail.com', password: 'qwerty')
      expect { user.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end

    it 'is invalid without a name' do
      user = User.new(email: 'franklin@gmail.com', name: 'Ajaps')
      expect { user.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password can't be blank")
    end
  end

  describe 'team' do
    it 'should return all agents and admins in the DB' do

      expect(User.team.pluck(:id)).to eq [admin.id, agent.id]
    end
  end
end
