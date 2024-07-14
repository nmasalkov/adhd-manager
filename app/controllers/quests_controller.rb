class QuestsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_quest, only: [:edit, :update, :destroy, :toggle_status, :destroy]
  before_action :check_if_too_many_quests

  def index
    @quests = current_user.quests.where(created_at: Date.today..)
    @any_reward = current_user.rewards.any?
    @quest = Quest.new
  end

  def create
    @quest = current_user.quests.new(quest_params)
    if @quest.save
      respond_to do |format|
        format.html { redirect_to quests_path, notice: 'Quest was successfully created.' }
        format.turbo_stream
      end
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @quest.update(quest_params)
      respond_to do |format|
        format.html { redirect_to quests_path, notice: 'Quest was successfully updated.' }
        format.turbo_stream
      end
    else
      render :edit
    end
  end

  def destroy
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to quests_path, notice: 'Quest was successfully destroyed.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@quest)) }
    end
  end

  def toggle_status
    completed = params[:completed]
    @quest.update(status: completed ? 1 : 0)

    @reward_message = nil
    if completed
      @reward_message = "YOU WON #{roll_rewards || 'NOTHING'}!"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_path, notice: 'Quest status was successfully updated.' }
    end
  end

  private

  def check_if_too_many_quests
    all_quests = current_user.quests.count
    raise 'too many rewards!' if all_quests > 300
  end

  def roll_rewards
    pool = []
    luck_index = current_user.luck_index
    current_user.rewards.all.each do |reward|
      rounded = reward.probability * 10
      pool.concat([reward.id] * rounded)
    end

    nils_quantity = [(1000 - pool.length - luck_index), 0].max
    pool.concat([nil] * nils_quantity)

    result = pool.sample

    if result
      print 'yay!'
      current_user.update!(luck_index: 0)
      print current_user.luck_index
      return Reward.find_by(id: result).title if result
    else
      print 'nay!'
      current_user.update!(luck_index: luck_index + 20)
      print current_user.luck_index

      nil
    end
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def quest_params
    params.require(:quest).permit(:title, :status)
  end
end
