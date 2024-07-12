class RewardsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :check_if_too_many_rewards

  def index
    @rewards = current_user.rewards
  end

  def edit
    @reward = Reward.find(params[:id])
  end

  def update
    @reward = Reward.find(params[:id])
    if @reward.update(reward_params)
      respond_to do |format|
        format.html { redirect_to @reward, notice: 'Reward was successfully updated.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@reward), partial: 'rewards/reward', locals: { reward: @reward }) }
      end
    else
      render :edit, status: :unprocessable_entity
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
end