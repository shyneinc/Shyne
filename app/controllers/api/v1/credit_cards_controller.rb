class Api::V1::CreditCardsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :check_type

  def index
    respond_with :api, current_user.balanced_customer.cards.find.map(&:attributes)
  end

  def create
    begin
      card = Balanced::Card.new(credit_card_params).save
      current_user.balanced_customer.add_card(card)
      render :json => card.attributes, :status => 201
    rescue Exception => ex
      render :json => {:error => "Card cannot be validated"}, :status => 401
    end
  end

  def destroy
    uri = "#{current_user.customer_uri}/cards/#{params[:id]}"
    card = Balanced::Card.find(uri)
    card.unstore
    render :json => {}, :status => 204
  end

  private

  def credit_card_params
    params.require(:credit_card).permit(:card_number, :expiration_year, :expiration_month, :security_code, :postal_code)
  end

  def check_type
    if current_user.role_type != 'Member'
      render :json => {:error => 'Only members can use this end-point'}, :status => 401
    end
  end
end
