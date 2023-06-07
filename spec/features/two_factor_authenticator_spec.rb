require 'spec_helper'

describe 'TwoFactorAuthenticator' do
  include CASino::Engine.routes.url_helpers

  subject { page }

  context 'when logged in' do
    before do
      sign_in
    end

    context 'with two-factor authentication enabled' do
      before do
        # sign_in
        enable_two_factor_authentication
        # a = CASino::TwoFactorAuthenticator.where(user_id: CASino::User.where(username: (options[:username] || 'testuser' )).id).first
      end

      describe 'disabling two-factor authentication' do
        before do
          click_button 'Disable'
        end

        it { should have_text 'authenticator was successfully deleted' }

        it 'deletes the two-factor authenticator' do
          CASino::TwoFactorAuthenticator.count.should == 0
        end
      end
    end
  end
end
