class Api::V1::BankAccountsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :check_type

  def index
    respond_with :api, current_user.balanced_customer.bank_accounts.find.map(&:attributes)
  end

  def create
    bank_account = Balanced::BankAccount.new(bank_account_params).save
    current_user.balanced_customer.add_bank_account(bank_account)
    render :json => bank_account.attributes, :status => 201
    #TODO: Proper error handeling
  end

  def destroy
    uri = "#{current_user.customer_uri}/bank_accounts/#{params[:id]}"
    bank_account = Balanced::BankAccount.find(uri)
    bank_account.unstore
    render :json => {}, :status => 204
    #TODO: Proper error handeling
  end

  private

  def bank_account_params
    params.require(:bank_account).permit(:name, :account_number, :routing_number, :type)
  end

  def check_type
    if current_user.role_type != 'Mentor'
      render :json => {:error => 'Only mentors can use this end-point'}, :status => 401
    end
  end
end
