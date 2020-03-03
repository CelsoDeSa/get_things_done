class Project < ApplicationRecord
    has_many :activities, -> { order('finished asc') }, dependent: :destroy
    validates :name, :begin, :end, presence: { message: "não pode estar em branco"}
    validates :name, uniqueness: { message: "tem que ser único"}

    def status
        if self.activities.due.first
            data_fim_do_projeto = self.end
            data_atividade_em_andamento = self.activities.due.first ? self.activities.due.first.end : "finalizado"

            (data_fim_do_projeto < data_atividade_em_andamento) ? ["danger", "ATRASADO"] : ["primary", "EM ANDAMENTO"]
        elsif self.activities.length > 0 && self.activities.due.length == 0
            ["success", "COMPLETO"]
        else
            ["light", "NÃO INICIADO"]
        end
    end

    def porcentagem_completa
        if !self.activities.empty?
            porcentagem = (self.activities.finished.length.to_f / self.activities.length.to_f) * 100
            porcentagem.to_i
        else
            0
        end
    end
end
