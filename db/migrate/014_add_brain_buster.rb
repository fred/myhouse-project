class AddBrainBuster < ActiveRecord::Migration
  class BrainBuster < ActiveRecord::Base; end;
  
  def self.up
    create_table "brain_busters", :force => true do |t|
      t.column :question, :string
      t.column :answer, :string
    end
    create "Who is Michael Jackson? Singer, Fireman or Engineer", "singer"
    create "What is two plus two?", "4"
    create "What is the number before Twelve?", "11"
    create "Five times Two is what?", "10"
    create "Four times Two is what?", "8"
    create "Three times Two is what?", "6"
    create "Insert the next number in this sequence: 10, 11, 12, 13, ??", "14"
    create "What is five times five?", "25"
    create "What is Two times Two?", "4"
    create "Ten divided by two is what?", "5"
    create "What day comes after Monday?", "tuesday"
    create "What day comes after Tuesday?", "wednesday"
    create "What day comes after Wednesday?", "friday"
    create "What day comes after Friday?", "saturday"
    create "What is the last month of the year?", "december"
    create "How many minutes are in an hour?", "60"
    create "Spell the word 'dog' backwards.", "god"
    create "What is the opposite of down?", "up"
    create "What is the opposite of north?", "south"
    create "What is the opposite of bad?", "good"
    create "What is 4 times four?", "16"
    create "What number comes after 21?", "22"
    create "What month comes before July?", "june"
    create "What month comes before March?", "april"
    create "What month comes before April?", "may"
    create "What month comes before June?", "july"
    create "How many months in a year? hint:12", "12"
    create "How many days in a week? hint:7", "7"
    create "What is fifteen divided by three?", "5"
    create "What is 14 minus 4?", "10"
    create "1+1 = ?", "2"
    create "2+2 = ?", "4"
    create "What comes next? 'Monday Tuesday Wednesday ?????'", "thursday"
    create "What is the missing letter? 'a b c d ? f'", "e"
    create "What is the missing letter? 'c d e f ? h'", "g"
    create "What is the missing number? '10 20 30 40 ? 60'", "50"
  end

  def self.down
    drop_table "brain_busters"
  end
  
  # create a logic captcha - answers should be lower case
  def self.create(question, answer)
    BrainBuster.create(:question => question, :answer => answer.downcase)
  end
  
end