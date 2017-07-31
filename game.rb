require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path(File.dirname(__FILE__))
GAME_DATA = Hashie::Mash.new YAML.load_file File.join(ROOT_PATH, '/game_data.yml')
TITLE_DATA = File.read File.join(ROOT_PATH, '/title.txt')
PASTEL = Pastel.new

class Card
  attr :card_key, :name, :text, :score, :color
  INDENT = ' ' * 5

  def initialize(card_key, lang=:en)
    @card_key = card_key
    card = GAME_DATA.cards[card_key]
    @name = card.lang[lang].name
    @text = card.lang[lang].text
    @score = card.score
    @color = card.color
  end

  def layout
    [name_layout, text_layout ].join("\n")
  end

  def name_layout
    PASTEL.black.send("on_#{@color.to_sym}").bold("[#{@name.center(8)}] (#{@score})")
  end

  def text_layout
    (INDENT + @text).each_char.each_slice(80).map(&:join).join("\n#{INDENT}")
  end

end

class GameScore
  attr :ai_score, :player_score
  def initialize(player_cards, ai_cards)
    @player_score = 0
    player_cards.count.times { |index| @player_score += card_score(index, player_cards, ai_cards) }

    @ai_score = 0
    ai_cards.count.times { |index| @ai_score += card_score(index, ai_cards, player_cards) }
  end

  def card_score(index, cards, opponent_cards)
    card = cards[index]
    return 0 if stamp_by_elephant?(cards, index)
    gain_score = 0
    case card.card_key
    when 'sheep'
      gain_score += neighbor_cards(cards, index).count('sheep') * 2
      gain_score += neighbor_cards(cards, index).count('owl') * 2
    when 'dog'
      gain_score += opponent_cards.map(&:card_key).count('wolf') * 2
      gain_score += opponent_cards.map(&:card_key).count('owl') * 2
    when 'chicken'
      gain_score += cards.map(&:card_key).count('chick') * 2
      gain_score += cards.map(&:card_key).count('owl') * 2
    end
    card.score + gain_score
  end

  def stamp_by_elephant?(cards, index)
    return false if cards[index].card_key == 'rat'
    neighbor_cards(cards, index).count('elephant') >= 1
  end

  def neighbor_cards(cards, index)
    # 両端のカードは隣接カードが1枚しかない
    [-1, 1].map do |gain|
      next nil unless (index + gain).between?(0, cards.count - 1)
      cards[index + gain].card_key
    end.compact
  end
end

class Game
  attr :player_hand, :ai_hand, :player_cards, :ai_cards

  def initialize
    @player_cards = []
    @ai_cards = []
    @ui = GameUI.new self
    @ui.show_title
    set_piles
    play_round
    play_round
    score = GameScore.new(player_cards, ai_cards)
    puts score.inspect
  end

  def play_round
    init_round
    seq = [[@pile1, @pile2], [@pile2, @pile1], [@pile1, @pile2]]
    seq.each do |player_pile, ai_pile|
      player_draft(player_pile)
      ai_draft(ai_pile)
      @ui.layout_game
    end
    @player_hand.size.times do
      player_cardplay
      ai_cardplay
      @ui.layout_game
    end
  end

  def init_round
    @player_hand = []
    @ai_hand = []
    @pile1 = @draft_piles.shift
    @pile2 = @draft_piles.shift
  end

  def ai_draft(pile)
    pile.shuffle!
    @ai_hand << pile.shift
    pile.shift # discord
  end

  def player_draft(pile)
    pick = @ui.select_card_cli(pile, 'Pickup card for your hand.')
    @player_hand << pile.slice!(pick[:index_num])
    discard = @ui.select_card_cli(pile, 'Discard from pile.')
    pile.slice!(discard[:index_num])
  end

  def player_cardplay
    pick = @ui.select_card_cli(@player_hand, 'Select a card to play.')
    @player_cards << @player_hand.slice!(pick[:index_num])
  end

  def ai_cardplay
    @ai_hand.shuffle!
    @ai_cards << @ai_hand.shift
  end

  def set_piles
# ドラフト用にカード束を四つ作る。(プレイヤー2人 * 2ラウンド)
    deck = []
    GAME_DATA.cards.keys.each do |key|
      GAME_DATA.cards[key].num.times do
        deck << Card.new(key)
      end
    end
    @draft_piles = deck.shuffle.each_slice(deck.count/4).to_a
  end

end

class GameUI
  def initialize(game)
    @game = game
  end

  def show_title
    clear_screen
    puts TITLE_DATA
    TTY::Prompt.new.yes?('INSERT a coin.')
    clear_screen
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def print_layout_hand
    puts "Picked #{@game.player_hand.map(&:name_layout).join(' ')}"
  end

  def print_layout_table
    return if @game.player_cards.empty?
    puts "[  AI  ] #{@game.ai_cards.map(&:name_layout).join(' ')}"
    puts ""
    puts "[Player] #{@game.player_cards.map(&:name_layout).join(' ')}"
    puts ""
  end

  def select_card_cli(pile, description)
    choice = TTY::Prompt.new.select(description) do |menu|
      pile.each_with_index do |card, index|
        menu.choice card.layout, {index_num: index}
      end
    end
    clear_screen
    choice
  end

  def layout_game
    print_layout_table
    puts ""
    print_layout_hand
  end
end

Game.new
