require 'rails_helper'

describe Participant do
  context 'associations' do
    it { should belong_to(:organizer) }
    it { should have_one(:image) }
    it { should accept_nested_attributes_for(:image) }
    it { should have_many(:submissions) }
    it { should have_many(:posts) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
    it { should have_many(:articles) }
    it { should have_many(:leaderboards) }
    it { should have_many(:ongoing_leaderboards) }
    it { should have_many(:participant_challenges) }
    it { should have_many(:dataset_file_downloads) }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { is_expected.to allow_value(FFaker::Lorem.characters(8)).for :password }
    it { is_expected.not_to allow_value(FFaker::Lorem.characters(7)).for :password }
    it { is_expected.to allow_value(FFaker::Lorem.characters(72)).for :password }
    it { is_expected.not_to allow_value(FFaker::Lorem.characters(73)).for :password }
  end

  context 'validations with instance variable' do
    before do
      @participant = build(:participant)
    end

    it "responds to admin? with admin attribute set to 'true'" do
      @participant.admin = true
      @participant.save!
      expect(@participant.admin?).to be true
    end

    describe 'when name is not present' do
      before { @participant.name = ' ' }
      it { should_not be_valid }
    end

    describe 'when email is not present' do
      before { @participant.email = ' ' }
      it { should_not be_valid }
    end

    describe 'when email format is invalid' do
      it 'should be invalid' do
        addresses = %w(participant@foo,com participant_at_foo.org example.participant@foo.
                       foo@bar_baz.com foo@bar+baz.com foo@bar..com)
        addresses.each do |invalid_address|
          @participant.email = invalid_address
          expect(@participant).not_to be_valid
        end
      end
    end

    describe 'when email format is valid' do
      it 'should be valid' do
        addresses = %w(participant@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
        addresses.each do |valid_address|
          @participant.email = valid_address
          expect(@participant).to be_valid
        end
      end
    end

    describe 'when email address is already taken' do
      before do
        participant_with_same_email = @participant.dup
        participant_with_same_email.email = @participant.email.upcase
        participant_with_same_email.save
      end

      it { should_not be_valid }
    end

    context 'methods' do
      describe '#disable_account' do
        it 'works' do
          participant = create(:participant)
          participant.disable_account('A reason')
          expect(participant.account_disabled).to eq(true)
          expect(participant.account_disabled_reason).to eq("A reason")
          expect(participant.inactive_message).to eq("Your account has been disabled. Please contact us at info@crowdai.org.")
          expect(participant.active_for_authentication?).to be false
        end
      end


      describe '#format_url' do
        it 'works for https' do
          participant = create(:participant, github: 'https://github.com/seanfcarroll')
          participant.format_url('github')
          expect(participant.github).to eq('https://github.com/seanfcarroll')
        end

        it 'works for http' do
          participant = create(:participant, website: 'http://www.seanfcarroll')
          participant.format_url('website')
          expect(participant.website).to eq('http://www.seanfcarroll')
        end
      end
    end

    context 'email preference defaults' do
      let(:participant) { create :participant }
      it 'verify preference table is created' do
        expect(participant.email_preferences.count).to eq(1)
      end

      it 'verify preference flags are correctly set' do
        email = participant.email_preferences.first
        expect(email.opt_out_all).to be false
        expect(email.newsletter).to be true
        expect(email.my_leaderboard).to be true
        expect(email.any_post).to be true
        expect(email.my_topic_post).to be true
        expect(email.any_leaderboard).to be true
      end
    end

    context 'API key' do
      let!(:participant) { create :participant }
      it 'verify API key is created when account created' do
        expect(participant.api_key.length).to eq(32)
      end

      it 'verify API key can be updated' do
        api_key = participant.api_key
        participant.set_api_key
        expect(participant.api_key.length).to eq(32)
        expect(participant.api_key).not_to eq(api_key)
      end
    end

  end
end
