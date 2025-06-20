# https://mermaid.live/edit#pako:eNrNl11v2zYUhv8KwZvKiB3YcVw7Qrf0I8PWiwJFWxTY5kFgxWOZmEwKFJXEy_Lfxw9FlkhZDrAVWC_ShOch-Z7Dw1fSA04FBRzjyWSy5qngG5bFa45QTvaiUjGC_M81d8GclOUNI5kkO0MgZEfQW1LCJyhEyZSQe_TgYubf5LOSjGfodUHUtjX8RkqyR6-3QCjI8hA4I3meSHFXRiNkmVboTjIFSQOYHyN0KxhtT6fURCNKFBmh91xBBrIV3zBOk2_7hNGI0RH6hZQtVWcUctBbHOLd1SfAy0pCsmE5JHDPSmVkegyHe2Wme7s_tuv1032hl4JOoWoadRZ7y7IbSNmO5IjsRMVVK3ZDFCCdJ4TVTvVopk8ijFAoU8kKxQRv5a1Eso3a1eio_Vno7U9KrTfgZAf9CSgiM1BJkEcLSSspgfcwLlfdLDnjneWFyIFwlIpdYY6u3QrN2LVOrQafnfN7vsnF3Xc7oFJUMoX_5ng-5oRzreu5J6T2BfSgEnItlSadKTaFwm5Ak_5UuFBQPlvsZ3JrJn2vuur6KcZJt37_prj1Te03N2NWemrN_P5Hu_kkaIERUUqWDeH5kHWYMORMyLOf4EIOKjLAgBwT7tPijVeFKbKOjFH_xNNK3TUa1OqQAbUO6NMbRE4Lqi_LoKKaGZBUE32awtBpUe5SHDSFkhwxoMgBfYKCyGk9Hwjjb4rCu6XeSTI7kEg90sLC-wJuxAf9nFFpB3zMa_VM_-kj4ZE6w5I--OXLr3H8UerHgkKF_a9VFVnxqKcgzQuOXjKFdyRPK22TQv4PanP2zYlKGE8k4RlEG52Udekx0q5mfjnqa19JzqifyFlBpFZDnfFGjBeV0o_OxoqvQ9QahOOMLXcICSVofU9x58IdwuTHbqF-3g9veGsU66fTdYMFj3SjxpUisfS1rYgphkfXpfBeW1_9PZmEhn8c7fbmcc5vj-Nk0MrHUb9HHBm22GTyY_O66RjvShnAvuG5aNDLJl6_DTkivG8G6fhe0MCGaBvRk8McFm_BIRKmFTLBniHiZR4CYWohE1hBiBwu19P5-e7Rl_cQe7Qr--D-1rBn_OrQ4ShG7gFvTbVztO0zj1FkXhh_eOE87cUoJA8L1mhta4bFY5xJRnG8IXkJY7wDuSPmb2x9Z43VFvQHA471rxQ2pMrVGq_5o55XEP6bEDscK1npmVJU2bZZx0mvP0UbBLj-mnxnvATHF3O7BI4f8D2OX16eX1ysrlaLxfxqOl-uZmO8x_F8eb66XM2W0_l0trqaLheXj2P8l910ev7yajGdLy4vVvP5YjabLccYqKnnB_e1bD-aH_8BLZ7DyQ
require 'bigdecimal'
require 'date'
require 'tty-prompt'

require_relative 'models/inflows'
require_relative 'models/expenses'
require_relative 'models/savings'
require_relative 'models/goals'
require_relative 'models/planner'

require_relative 'services/validator'
require_relative 'services/balance_calculator'


require_relative 'repositories/base_repository'
require_relative 'repositories/inflows_repository'
require_relative 'repositories/expenses_repository'
require_relative 'repositories/savings_repository'
require_relative 'repositories/goals_repository'
require_relative 'repositories/planner_repository'

DATA_FOLDER = File.join(__dir__, 'data')
Dir.mkdir(DATA_FOLDER) unless Dir.exist?(DATA_FOLDER)

inflow_repo  = InflowRepository.new(DATA_FOLDER)
expense_repo = ExpenseRepository.new(DATA_FOLDER)
saving_repo  = SavingRepository.new(DATA_FOLDER)
goal_repo    = GoalRepository.new(DATA_FOLDER)
planner_repo = PlannerRepository.new(DATA_FOLDER)

prompt = TTY::Prompt.new

class QuitToMenu < StandardError; end

def ask_or_quit(prompt, message, **opts)
  input = prompt.ask("#{message} (albo 'q' aby wrócić)", **opts)
  raise QuitToMenu if input == 'q'
  input
end

def select_or_quit(prompt, message, choices, **opts)
  menu_choices = choices + [{ name: 'Powrót', value: :_quit }]
  choice = prompt.select("#{message} (lub 'q')", menu_choices, **opts)
  raise QuitToMenu if choice == :_quit
  choice
end
    

system('clear') || system('cls') 
prompt.say("=== APLIKACJA FINANSOWA ===\nAutor: Wiktoria Szczepaniak")
prompt.keypress("Kliknij klawisz aby kontynuować")
loop do
  begin
    check = goal_repo.all
    check.each do |i|
      if i.deadline < Date.today
        goal_repo.update(i.id, completed: 'flase')
      end
    end
    system('clear') || system('cls') 
    choice = prompt.select("=== APLIKACJA FINANSOWA ===", cycle: true) do |menu|
      menu.choice 'Dodaj przychód',        :add_inflow
      menu.choice 'Zobacz przychody',      :view_inflows
      menu.choice 'Edytuj przychód',       :edit_inflow
      menu.choice 'Usuń przychód',         :delete_inflow
      menu.choice 'Dodaj wydatek',         :add_expense
      menu.choice 'Zobacz wydatki',        :view_expenses
      menu.choice 'Edytuj wydatek',        :edit_expense
      menu.choice 'Usuń wydatek',          :delete_expense
      menu.choice 'Dodaj oszczędność',     :add_saving
      menu.choice 'Zobacz oszczędności',   :view_savings
      menu.choice 'Edytuj oszczędność',    :edit_saving
      menu.choice 'Usuń oszczędność',      :delete_saving
      menu.choice 'Ustaw cel',             :set_goal
      menu.choice 'Zobacz cele',           :view_goals
      menu.choice 'Usuń cel',              :delete_goal
      menu.choice 'Dodaj do planera',      :add_planner
      menu.choice 'Zobacz planer',         :view_planner
      menu.choice 'Usuń z planera',        :delete_planner
      menu.choice 'Zobacz salda',          :view_balances
      menu.choice 'Wyjście',               :exit
    end

    case choice
    when :add_inflow
      amount_str  = ask_or_quit(prompt, 'Kwota:', required: true)
      date_str = prompt.ask('Data (YYYY-MM-DD):')
      source      = ask_or_quit(prompt, 'Źródło:', required: true)
      description = ask_or_quit(prompt, 'Opis (opcjonalnie):')
      amount = Validator.parse_decimal(amount_str)
      date   = Validator.parse_date(date_str) || Date.today
      if amount.nil? || date.nil? || source.strip.empty?
        prompt.error("Nieprawidłowe dane. Sprawdź kwotę, datę i źródło.")
        next
      end
      link_to_goal = prompt.yes?("Czy chcesz powiązać ten wydatek z celem?")

      if link_to_goal
        goals = goal_repo.all.reject(&:completed?)
        if goals.empty?
          prompt.warn("Brak aktywnych celów. Wydatek zostanie zapisany normalnie.")
        else
          goal_choices = goals.map { |g| { name: "#{g.name} (#{sprintf('%.2f', g.current_amount)}/#{sprintf('%.2f', g.target_amount)})", value: g.id } }
          selected_goal_id = prompt.select("Wybierz cel, do którego chcesz dodać ten wydatek:", goal_choices)
          selected_goal    = goal_repo.find(selected_goal_id)
          raw_new_amount = selected_goal.current_amount + amount
          new_amount = sprintf('%.2f', Validator.parse_decimal(raw_new_amount))
          goal_repo.update(selected_goal.id, current_amount: new_amount, completed: (raw_new_amount >= selected_goal.target_amount))
        end
      end
      inflow = inflow_repo.create(
        amount:      sprintf('%.2f', amount),
        date:        date.to_s,
        source:      source,
        description: description || '(brak opisu)'
      )
      prompt.ok("Dodano przychód o ID #{inflow.id}.")
      prompt.keypress()

    when :view_inflows
      inflows = inflow_repo.all
      prompt.say("\n--- PRZYCHODY ---")
      if inflows.empty?
        prompt.say("Brak przychodów.")
      else
        inflows.each do |i|
          prompt.say("[#{i.id}] #{i.date} - #{i.source}: #{sprintf('%.2f', i.amount)} PLN - #{i.description}\n")
        end
      end
      prompt.keypress("\nEnter aby wrócić…")

    when :edit_inflow
      inflows = inflow_repo.all
      if inflows.empty?
        prompt.say("Brak przychodów do edycji.")
      else
        id = select_or_quit(prompt, "Wybierz przychód do edycji:", 
          inflows.map { |i| { name: "[#{i.id}] #{i.source} (#{sprintf('%.2f', i.amount)})", value: i.id } }
        )
        rec = inflow_repo.find(id)
        amt_str  = ask_or_quit(prompt, "Kwota:", default: sprintf('%.2f', rec.amount))
        date_str = ask_or_quit(prompt, "Data (YYYY-MM-DD):", default: rec.date.to_s)
        src      = ask_or_quit(prompt, "Źródło:", default: rec.source)
        desc     = ask_or_quit(prompt, "Opis:", default: rec.description)
        inflow_repo.update(id,
          amount:      sprintf('%.2f', Validator.parse_decimal(amt_str)),
          date:        date_str,
          source:      src,
          description: desc
        )
        prompt.ok("Zaktualizowano przychód #{id}.")
        prompt.keypress()
      end

    when :delete_inflow
      inflows = inflow_repo.all
      if inflows.empty?
        prompt.say("Brak przychodów do usunięcia.")
      else
        id = select_or_quit(prompt, "Wybierz przychód do usunięcia:", 
          inflows.map { |i| { name: "[#{i.id}] #{i.source} #{sprintf('%.2f', i.amount)}", value: i.id } }
        )
        inflow_repo.delete(id)
        prompt.ok("Usunięto przychód o ID #{id}.")
        prompt.keypress()
      end

    when :add_expense
      amount_str  = ask_or_quit(prompt, 'Kwota:', required: true)
      date_str    = ask_or_quit(prompt, 'Data (YYYY-MM-DD):', required: false)
      category    = ask_or_quit(prompt, 'Przeznaczenie:', required: true)
      description = ask_or_quit(prompt, 'Opis (opcjonalnie):')
      amount = Validator.parse_decimal(amount_str)
      date   = Validator.parse_date(date_str) || Date.today
      if amount.nil? || date.nil? || category.strip.empty?
        prompt.error("Nieprawidłowe dane. Sprawdź kwotę, datę i kategorię.")
        next
      end
      link_to_goal = prompt.yes?("Czy chcesz powiązać ten wydatek z celem?")

      if link_to_goal
        goals = goal_repo.all.reject(&:completed?)
        if goals.empty?
          prompt.warn("Brak aktywnych celów. Wydatek zostanie zapisany normalnie.")
        else
          goal_choices = goals.map { |g| { name: "#{g.name} (#{sprintf('%.2f', g.current_amount)}/#{sprintf('%.2f', g.target_amount)})", value: g.id } }
          selected_goal_id = prompt.select("Wybierz cel, do którego chcesz dodać ten wydatek:", goal_choices)
          selected_goal    = goal_repo.find(selected_goal_id)
          raw_new_amount = selected_goal.current_amount + amount
          new_amount = sprintf('%.2f', Validator.parse_decimal(raw_new_amount))
          goal_repo.update(selected_goal.id, current_amount: new_amount, completed: (raw_new_amount >= selected_goal.target_amount))
        end
      end
      expense = expense_repo.create(
        amount:      sprintf('%.2f', amount),
        date:        date.to_s,
        category:    category,
        description: description || '(brak opisu)'
      )
      prompt.ok("Dodano wydatek o ID #{expense.id}.")
      prompt.keypress()

    when :view_expenses
      exps = expense_repo.all
      prompt.say("\n--- WYDATKI ---")
      if exps.empty?
        prompt.say("Brak wydatków.")
      else
        exps.each do |e|
          prompt.say("[#{e.id}] #{e.date} - #{e.category}: #{sprintf('%.2f', e.amount)} PLN - #{e.description}\n")
        end
      end
      prompt.keypress("\nEnter aby wrócić…")

    when :edit_expense
      exps = expense_repo.all
      if exps.empty?
        prompt.say("Brak wydatków do edycji.")
      else
        id = select_or_quit(prompt, "Wybierz wydatek do edycji:", 
          exps.map { |e| { name: "[#{e.id}] #{e.category} (#{sprintf('%.2f', e.amount)})", value: e.id } }
        )
        rec = expense_repo.find(id)
        amt_str  = ask_or_quit(prompt, "Kwota:", default: sprintf('%.2f', rec.amount))
        date_str = ask_or_quit(prompt, "Data (YYYY-MM-DD):", default: rec.date.to_s)
        cat      = ask_or_quit(prompt, "Przeznaczenie:", default: rec.category)
        desc     = ask_or_quit(prompt, "Opis:", default: rec.description)
        expense_repo.update(id,
          amount:      sprintf('%.2f', Validator.parse_decimal(amt_str)),
          date:        date_str,
          category:    cat,
          description: desc
        )
        prompt.ok("Zaktualizowano wydatek #{id}.")
        prompt.keypress()
      end

    when :delete_expense
      expenses = expense_repo.all
      if expenses.empty?
        prompt.say("Brak wydatków do usunięcia.")
      else
        id = select_or_quit(prompt, "Wybierz wydatek do usunięcia:", 
          expenses.map { |e| { name: "[#{e.id}] #{e.category} #{sprintf('%.2f', e.amount)}", value: e.id } }
        )
        expense_repo.delete(id)
        prompt.ok("Usunięto wydatek o ID #{id}.")
        prompt.keypress()
      end

    when :add_saving
      amount_str   = ask_or_quit(prompt, 'Kwota:', required: true)
      date_str     = ask_or_quit(prompt, 'Data (YYYY-MM-DD):', required: false)
      destination  = ask_or_quit(prompt, 'Przeznaczenie:', required: true)
      description  = ask_or_quit(prompt, 'Opis (opcjonalnie):')
      amount = Validator.parse_decimal(amount_str)
      date   = Validator.parse_date(date_str) || Date.today
      if amount.nil? || date.nil? || destination.strip.empty?
        prompt.error("Nieprawidłowe dane. Sprawdź kwotę, datę i przeznaczenie.")
        next
      end
      saving = saving_repo.create(
        amount:      sprintf('%.2f', amount),
        date:        date.to_s,
        destination: destination,
        description: description || '(brak opisu)'
      )
      prompt.ok("Dodano oszczędność o ID #{saving.id}.")
      prompt.keypress()

    when :view_savings
      saves = saving_repo.all
      prompt.say("\n--- OSZCZĘDNOŚCI ---")
      if saves.empty?
        prompt.say("Brak oszczędności.")
      else
        saves.each do |s|
          prompt.say("[#{s.id}] #{s.date} - #{s.destination}: #{sprintf('%.2f', s.amount)} PLN - #{s.description}\n")
        end
      end
      prompt.keypress("\nEnter aby wrócić…")

    when :edit_saving
      saves = saving_repo.all
      if saves.empty?
        prompt.say("Brak oszczędności do edycji.")
      else
        id = select_or_quit(prompt, "Wybierz oszczędność do edycji:", 
          saves.map { |s| { name: "[#{s.id}] #{s.destination} (#{sprintf('%.2f', s.amount)})", value: s.id } }
        )
        rec = saving_repo.find(id)
        amt_str  = ask_or_quit(prompt, "Kwota:", default: sprintf('%.2f', rec.amount))
        date_str = ask_or_quit(prompt, "Data (YYYY-MM-DD):", default: rec.date.to_s)
        dest     = ask_or_quit(prompt, "Przeznaczenie:", default: rec.destination)
        desc     = ask_or_quit(prompt, "Opis:", default: rec.description)
        amount = Validator.parse_decimal(amt_str)
        link_to_goal = prompt.yes?("Czy chcesz powiązać z celem?")
        if link_to_goal
          goals = goal_repo.all.reject(&:completed?)
          if goals.empty?
            prompt.warn("Brak aktywnych celów. Edycja zostanie normalnie zapisana.")
            saving_repo.update(id,
              amount:      sprintf('%.2f', Validator.parse_decimal(amt_str)),
              date:        date_str,
              destination: dest,
              description: desc
            )

          else
            goal_choices = goals.map { |g| { name: "#{g.name} (#{sprintf('%.2f', g.current_amount)}/#{sprintf('%.2f', g.target_amount)})", value: g.id } }
            selected_goal_id = prompt.select("Wybierz cel, do którego chcesz dodać ten wydatek:", goal_choices)
            selected_goal    = goal_repo.find(selected_goal_id)
            raw_new_amount = selected_goal.current_amount + amount
            new_amount = sprintf('%.2f', Validator.parse_decimal(raw_new_amount))
            goal_repo.update(selected_goal.id, current_amount: new_amount, completed: (raw_new_amount >= selected_goal.target_amount))
            saving_repo.delete(id)
          end
        else
          saving_repo.update(id,
            amount:      sprintf('%.2f', Validator.parse_decimal(amt_str)),
            date:        date_str,
            destination: dest,
            description: desc
          )
          prompt.ok("Zaktualizowano oszczędność #{id}.")
          prompt.keypress()
        end
      end

    when :delete_saving
      savings = saving_repo.all
      if savings.empty?
        prompt.say("Brak oszczędności do usunięcia.")
      else
        id = select_or_quit(prompt, "Wybierz oszczędność do usunięcia:", 
          savings.map { |s| { name: "[#{s.id}] #{s.destination} #{sprintf('%.2f', s.amount)}", value: s.id } }
        )
        saving_repo.delete(id)
        prompt.ok("Usunięto oszczędność o ID #{id}.")
        prompt.keypress()
      end

    when :set_goal
      name         = ask_or_quit(prompt, 'Nazwa celu:', required: true)
      target_str   = ask_or_quit(prompt, 'Kwota docelowa:', required: true)
      current_str  = ask_or_quit(prompt, 'Aktualna kwota:', required: true)
      deadline_str = ask_or_quit(prompt, 'Termin (YYYY-MM-DD):', required: true)

      target   = Validator.parse_decimal(target_str)
      current  = Validator.parse_decimal(current_str)
      deadline = Validator.parse_date(deadline_str)

      if name.strip.empty? || target.nil? || current.nil? || deadline.nil?
        prompt.error("Nieprawidłowe dane. Sprawdź nazwę, kwoty i termin.")
        next
      end
      goal = goal_repo.create(
        name:           name,
        target_amount:  sprintf('%.2f', target),
        current_amount: sprintf('%.2f', current),
        deadline:       deadline.to_s,
        completed:      ''
      )
      prompt.ok("Dodano cel o ID #{goal.id}.")
      prompt.keypress()

    when :view_goals
      goals = goal_repo.all
      prompt.say("\n--- CELE ---")
      if goals.empty?
        prompt.say("Brak ustawionych celów.")
      else
        goals.each do |g|
          progress = (g.current_amount / g.target_amount * 100).to_f
          status   = g.completed? ? 'Zrealizowany' : g.deadline < Date.today ? 'Niezrealizowany' : 'W toku'
          prompt.say("[#{g.id}] #{g.name} - #{sprintf('%.2f%%', progress)} "\
                     "(#{sprintf('%.2f', g.current_amount)}/#{sprintf('%.2f', g.target_amount)}) "\
                     "- termin: #{g.deadline} - #{status}\n")
        end
      end
      prompt.keypress("\nEnter aby wrócić…")

    when :delete_goal
      goals = goal_repo.all
      if goals.empty?
        prompt.say("Brak celów do usunięcia.")
      else
        id = select_or_quit(prompt, "Wybierz cel do usunięcia:", 
          goals.map { |g| { name: "[#{g.id}] #{g.name}", value: g.id } }
        )
        goal_repo.delete(id)
        prompt.ok("Usunięto cel o ID #{id}.")
        prompt.keypress()
      end

    when :add_planner
      type       = select_or_quit(prompt, 'Typ wpisu w planowaniu:', [
        { name: 'Przychód', value: 'Przychód' },
        { name: 'Wydatek',  value: 'Wydatek' },
        { name: 'Inny',     value: 'Inny'}
      ])
      date_str   = ask_or_quit(prompt, 'Planowana data (YYYY-MM-DD):')
      notes      = ask_or_quit(prompt, 'Opis:', required: true)
      date = Validator.parse_date(date_str) || Date.today
      if date.nil?
        prompt.error("Nieprawidłowa data.")
        next
      end
      planner = planner_repo.create(
        type:         type,
        planned_date: date.to_s,
        notes:        notes 
      )
      prompt.ok("Dodano do planera pozycję o ID #{planner.id}.")
      prompt.keypress()

    when :view_planner
      items = planner_repo.all
      prompt.say("\n--- PLANER ---")
      if items.empty?
        prompt.say("Brak zaplanowanych pozycji.")
      else
        items.each do |p|
          type_label = p.type
          prompt.say(
            "[#{p.id}] #{type_label} - "\
            "#{p.planned_date} - #{p.notes} \n"
          )
        end
      end
      prompt.keypress("\nEnter aby wrócić…")

    when :delete_planner
      planner = planner_repo.all
      if planner.empty?
        prompt.say("Brak pozycji w planerze do usunięcia.")
      else
        id = select_or_quit(prompt, "Wybierz pozycję z planera do usunięcia:", 
          planner.map { |p| { name: "[#{p.id}] #{p.type} na #{p.planned_date}", value: p.id } }
        )
        planner_repo.delete(id)
        prompt.ok("Usunięto pozycję z planera o ID #{id}.")
        prompt.keypress()
      end

    when :view_balances
      balance_calc = BalanceCalculator.new(inflow_repo, expense_repo, saving_repo, goal_repo)
      from_str = prompt.ask('Data od (YYYY-MM-DD):')
      to_str   = prompt.ask('Data do (YYYY-MM-DD):')
      
      from_date = Validator.parse_date(from_str) if from_str && !from_str.empty?
      to_date   = Validator.parse_date(to_str)   if to_str && !to_str.empty?

      balance = balance_calc.balance_in_range(from_date: from_date, to_date: to_date)
      
      prompt.say("\n--- PODSUMOWANIE ---")
      prompt.say("Suma przychodów:     #{sprintf('%.2f', balance[:inflows])} PLN")
      prompt.say("Suma wydatków:       #{sprintf('%.2f', balance[:expenses])} PLN")
      prompt.say("Suma oszczędności:   #{sprintf('%.2f', balance[:savings])} PLN")
      prompt.say("Saldo:               #{sprintf('%.2f', balance[:balance])} PLN")
      
      if balance_calc.goals_progress.any?
        prompt.say("\n--- CELE ---")
        balance_calc.goals_progress.each do |gp|
          goal = gp[:goal]
          prompt.say(
            "#{goal.name}: #{gp[:progress]}% " \
            "(#{sprintf('%.2f', goal.current_amount)}/#{sprintf('%.2f', goal.target_amount)})"
          )
        end
      end
      
      prompt.keypress("\nNaciśnij Enter aby wrócić...")

    when :exit
      break
    end

  rescue QuitToMenu
    next
  end
end
