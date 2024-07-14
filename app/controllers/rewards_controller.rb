class RewardsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :check_if_too_many_rewards
  before_action :set_reward, only: [:edit, :update, :destroy]

  def index
    @rewards = current_user.rewards
  end

  def edit
  end

  def new
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)
    @reward.user = current_user

    if @reward.save
      redirect_to rewards_path, notice: 'Reward was successfully created.'
    else
      flash.now[:alert] = @reward.errors.full_messages.to_sentence
      render :index
    end
  end

  def update
    if @reward.update(reward_params)
      respond_to do |format|
        format.html { redirect_to @reward, notice: 'Reward was successfully updated.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@reward), partial: 'rewards/reward', locals: { reward: @reward }) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reward.destroy
    respond_to do |format|
      format.html { redirect_to rewards_path, notice: 'Reward was successfully destroyed.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@reward)) }
    end
  end

  private

  def check_if_too_many_rewards
    all_rewards = current_user.rewards.count
    raise 'too many rewards!' if all_rewards > 30
  end

  def reward_params
    params.require(:reward).permit(:title, :probability)
  end

  def set_reward
    @reward = Reward.find(params[:id])
  end
end
