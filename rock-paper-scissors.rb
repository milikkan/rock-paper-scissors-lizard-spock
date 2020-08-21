require 'yaml'

VALID_CHOICES = %w(rock paper scissors spock lizard)
ABBREVIATED_CHOICES = %w(r p sc sp l)

WINNING_RULES = {
  rock: ['lizard', 'scissors'],
  paper: ['rock', 'spock'],
  scissors: ['paper', 'lizard'],
  spock: ['scissors', 'rock'],
  lizard: ['paper', 'spock']
}

WINNING_MESSAGES = YAML.load_file('winning_messages.yml')

def clear_screen
  system("clear") || system("cls")
end

# prints a horizontal line for text seperation
def hr(number, char='-')
  puts char * number
end

# adds vertical clearance
def spacer(lines=1)
  lines.times { puts }
end

def prompt(message)
  puts "=> #{message}"
end

def display_welcome_message
  clear_screen
  banner_message = "  WELCOME TO 'Rock-Paper-Scissors-SPOCK-LIZARD' GAME  "
  hr(banner_message.length, '=')
  puts banner_message
  puts "      Game is over when either player reaches 5"
  hr(banner_message.length, '=')
end

def display_score(scores)
  spacer
  puts "   PLAYER| #{scores[:player]}   -   #{scores[:computer]} |COMPUTER"
  spacer
end

def display_selection_menu
  choice_prompt = <<-MSG
    * Rock (r)
    * Paper (p)
    * Scissors (sc)
    * Spock (sp)
    * Lizard (l)
  MSG
  puts choice_prompt
end

def valid_choice?(choice)
  VALID_CHOICES.include?(choice) || ABBREVIATED_CHOICES.include?(choice)
end

def convert_to_long_choice(choice)
  index = ABBREVIATED_CHOICES.index(choice)
  index ? VALID_CHOICES[index] : choice
end

def retrieve_player_choice
  loop do
    prompt("Choose one, you also can type abbreviations:")
    choice = gets.chomp.strip.downcase

    break convert_to_long_choice(choice) if valid_choice?(choice)
    prompt("That's not a valid choice.")
  end
end

def retrieve_computer_choice
  VALID_CHOICES.sample
end

def display_choices(player, computer)
  prompt("You chose: #{player.upcase}; Computer chose: #{computer.upcase}")
end

def determine_winner(first, second)
  if first == second
    'tie'
  elsif WINNING_RULES[first.to_sym].include?(second)
    'player'
  else
    'computer'
  end
end

def determine_phrase(winner, player, computer)
  if winner == 'player'
    WINNING_MESSAGES[player][computer]
  elsif winner == 'computer'
    WINNING_MESSAGES[computer][player]
  else
    ''
  end
end

def display_round_result(winner, phrase)
  if winner == 'tie'
    prompt('It is a tie!')
  else
    prompt("#{phrase}. ###### #{winner.upcase} won!")
  end
end

def update_score(scores, winner)
  scores[winner.to_sym] += 1
end

def game_won?(scores)
  scores[:player] == 5 || scores[:computer] == 5
end

def display_game_result(scores)
  spacer
  if scores[:player] == 5
    puts "Player won the game"
  else
    puts "Computer won the game"
  end
  spacer
end

def prompt_for_next_round
  spacer
  prompt("Hit 'Enter' to play the next round...")
  gets
end

def retrieve_new_game_answer
  loop do
    prompt('Do you want to play again? (enter y/yes or n/no)')
    answer = gets.chomp.downcase
    break answer if %w(y yes n no).include?(answer)
    prompt("Invalid input...Enter y/yes to play again, n/no to stop.")
  end
end

loop do # main game loop
  scores = { player: 0, computer: 0 }

  loop do
    display_welcome_message
    display_score(scores)
    display_selection_menu

    player_choice = retrieve_player_choice
    computer_choice = retrieve_computer_choice
    display_choices(player_choice, computer_choice)

    winner = determine_winner(player_choice, computer_choice)
    phrase = determine_phrase(winner, player_choice, computer_choice)
    display_round_result(winner, phrase)

    update_score(scores, winner) unless winner == 'tie'

    if game_won?(scores)
      prompt("GAME OVER...")
      display_score(scores)
      display_game_result(scores)
      break
    end

    prompt_for_next_round
  end

  new_game = retrieve_new_game_answer
  break unless %w(y yes).include?(new_game)
end # end main loop

prompt('Thank you for playing. Good bye!')
