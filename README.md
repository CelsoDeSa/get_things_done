# README

Este é um aplicativo simples de gerenciamento de tarefas.

Por isso apelidei ele usando base o nome do livro do David Allen [Getting Things Done](https://www.amazon.com.br/Getting-Things-Done-Stress-Free-Productivity-ebook/dp/B00KWG9M2E/ref=sr_1_2?__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&keywords=getting+things+done&qid=1583209870&sr=8-2).

Você pode ver a versão live do [GTD aqui](https://gtdtest.herokuapp.com/).

Ele foi desenvolvido basicamente usando:

- Rails 5.2
- JQuery
- Twitter Bootstrap 4 e Font Awesome Icons
- Postgresql

## Rails 5.2 e Postgresql

Aqui eu criei dois Models principais: Projects e Activity.

Via a técnica de "nested resources" eu relacionei os dois no routes.rb.

```
#routes.rb

...

resources :projects, path: :projetos do
    resources :activities, path: :atividades
end

...
```

Isso permitiu criar urls mais elegantes, mas não só isso:

Essa ténica permitiu gerar outros meios práticos de manipular e interagor com os dados no banco de dados Postgresq.

Por exemplo, quando criei o Model Activity eu gerei uma foreign_key antes de migrar o modelo.

```
#db/migrate/xxxxxxxxxxxxxxx_create_activities.rb

class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      ...
      t.belongs_to :project, foreign_key: true

      ...
    end
  end
end
```

Isso permite que sempre que eu for criar uma atividade primeiro eu já teria que ter criado um projeto.

A vantagem está que aquela atividade para sempre está conectada com o projeto e como eu adicionei um dependent: :destroy, quando um projeto for deleta todas as suas atividades são também.

```
#app/models/project.rb

class Project < ApplicationRecord
    has_many :activities, -> { order('finished asc') }, dependent: :destroy
    ...
end
```

Isso é "future-proof" (à prova do futuro), porque previne que o banco de dados fique cheio de dados inúteis.

Como reforcei essa conexão dos dois Models por meio dos métods belongs_to e has_many eu consigo facilmente comparar, por exemplo, as datas finais de um projeto com a data final de uma atividade e checar se o projeto está atrasado.

```
#app/models/activity.rb

class Activity < ApplicationRecord
  belongs_to :project
  ...
  scope :finished, -> { where(finished: true) }

  ...

  def finalizada
    self.finished ? ["success", "finalizada"] : ["primary", "em andamento"]
  end
end
```

Além disso com isso eu posso também mudar a cor do texto da data final da atividade para vermelho:

```
#views/projects/show.html.erb

...
<td class="text-<%= activity.date_overdue %>"><%= activity.end.strftime('%d/%m/%Y') %></td>
...
```

Isso renderiza assim:

```
<td class="text-danger">05/03/2020</td>
```

Uma clara indicação visual de que a atividade está fora do prazo geral do projeto.


## Bootstrap 4 e Font Awesome

Não tenho como descrever como esses recursos já me ajudaram, agilizando o desenvolvimento/embelezamento dos meus projetos pessoais.

O Bootstrap 4 não só deixa o site mais bonito, mas usei o grid system dele para fazer o site ficar responsivo à diferentes tamanhos de telas de dispositivos.

a gem 'font-awesome-sass' dá uns helper methods que facilitam muito a inclusão de ícones de uma maneira enxuta onde é necessário.

Todos esses elementos juntos permitem que rapidamente eu possa desenvolver um site agradável e moderno.

Além disso "embutir" (embed) o ruby junto às classes do Bootstrap permite gerar todo o tipo de efeito interessante e dicas visuais dinâmicas nas páginas que eu possa criar.

Esse trecho é um exemplo:

```
#views/projects/show.html.erb

<span class="badge badge-pill badge-<%= activity.finalizada[0] %>">
    <%= activity.finalizada[1] %>
</span>  
```

Isso funciona porque no Model Activity existe esse método

```
def finalizada
    self.finished ? ["success", "finalizada"] : ["primary", "em andamento"]
end
```

Ele retorna uma Array que então é "embutida" nas classes do Bootstrap para geral o efeito necessário.

Se a tarefa está terminada renderiza de uma maneira:

```
<span class="badge badge-pill badge-success">
    finalizada
</span> 
```

Se ela não está checada como finalizada:

```
<span class="badge badge-pill badge-primary">
    em andamento
</span> 
```

## JQuery

Esse foi meu aliado para conseguir trazer uma experiência mais agradável à escolha de datas.

Isso porque a versão nativa do Rails quasem fazem os olhos sangrar...

Então encontrei a solução perfeita que casa com o Bootstrap: o Datepicker reunida na maravilhosa gem 'bootstrap-datepicker-rails'.

Um achado, preciso pagar uma cerveja para o criador dessa gem um dia desses.

aqui foi só dicioná-la com a turma dela:

```
#Gemfile

...

# Styles & Bootstrap Requirements
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap-datepicker-rails'
gem 'jquery-rails'
gem 'material_icons'
gem 'font-awesome-sass'
...
```

Dar um  `bundle install`

E completar a instalação nos assets JS da aplicação:

```
#app/assets/javascripts/application.js

// Bootstrap Stuff
...
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pt-BR.js

//= require_tree .
...
```

Após ter requirido o bootstrap-datapicker nessa mesma pasta adicionei umas configs básicas do Datepicker para ele usar o português brasileiro como padrão.

```
$(document).on("turbolinks:load",function(){
    $('.nav-item').tooltip();
    $('.datepicker').datepicker({
      language: 'pt-BR'
    });
  })
```

Também não podia esquecer de requerer os arquivos sccs dele para ele ficar bonito.

Escolhi a opção datepicker3, mais moderno na minha opinião.

```
#app/assets/stylesheets.application.scss

...
 *
 *= require bootstrap-datepicker3
 *= require_tree .
 *= require_self
 */
 ...
```

Com isso pronto é só chamar adicionar `datepicker` à classe do input que eu quero que apareça as opções de data em português BR.

## Conclusão

Foi bem divertido desenvolver esse pequeno projeto.

Trabalhei nele como se fosse criar um gerenciador que eu gostaria de usar: fácil, prático e rápido.

A minha esposa gostou tanto dele que colaborou com os projetos e atividades modelo da versão live.

Acho que um desenvolvedor difícilmente consegue dizer que um app está pronto, não é?

Eu ainda gostaria de testar esse aplicativo usando Rspec e usar JS para adicionar/remover projetos e atividades.

E eu ficaria muito feliz de adicionar uma função JS que mudasse a ordem dinamicamente das atividades (à la drag and drop).

Vai ficar para as próximas iterações.

Ou quem sabe vou trabalhar no projeto real, heim heim? :wink:
