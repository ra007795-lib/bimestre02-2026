/*
===============================================================================
TRABALHO PRÁTICO 01 - GESTÃO DE BANCO DE DADOS (PostgreSQL)
Bimestre: 2º Bimestre / 2026
Aluno: [Pedro Henrique Aparecido da Silva Costa]
RA: [007795]

JUSTIFICATIVA E CONTEXTUALIZAÇÃO DO TEMA:
O tema escolhido é "Tecnologia", focado no domínio de uma plataforma SaaS de 
ensino e capacitaçã. O sistema gerencia o cadastro de instrutores, cursos oferecidos, alunos matriculados, matrículas 
realizadas e as avaliações dos cursos. O objetivo é fornecer uma visão 360º 
da operação comercial e pedagógica da edtech.
===============================================================================
*/

-- ============================================================================
-- ESTRUTURA DE TABELAS (DDL)
-- ============================================================================

/*
TABELA: instrutores
Finalidade e objetivo operacional: Armazena os dados dos professores e 
especialistas responsáveis pela ministração dos cursos de tecnologia.
*/
CREATE TABLE instrutores (
    id_instrutor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    especialidade VARCHAR(50) NOT NULL,
    valor_hora_aula NUMERIC(10, 2) NOT NULL CHECK (valor_hora_aula > 0), -- RESTRIÇÃO CHECK 1
    data_admissao DATE DEFAULT CURRENT_DATE NOT NULL
);

/*
TABELA: cursos
Finalidade e objetivo operacional: Registra os cursos de tecnologia disponíveis, 
suas cargas horárias, preços e o instrutor responsável pela ministração.
*/
CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('Iniciante', 'Intermediário', 'Avançado')), -- RESTRIÇÃO CHECK 2
    preco NUMERIC(10, 2) NOT NULL CHECK (preco >= 0), -- RESTRIÇÃO CHECK 3
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0),
    id_instrutor INT NOT NULL,
    CONSTRAINT fk_cursos_instrutores FOREIGN KEY (id_instrutor) 
        REFERENCES instrutores(id_instrutor) ON DELETE CASCADE
);

/*
TABELA: alunos
Finalidade e objetivo operacional: Mantém os dados cadastrais dos estudantes 
que consomem os conteúdos da plataforma.
*/
CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

/*
TABELA: matriculas
Finalidade e objetivo operacional: Registra a relação N:M entre Alunos e Cursos, 
armazenando a data da compra/matrícula, o status financeiro/pedagógico e o valor pago.
*/
CREATE TABLE matriculas (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_curso INT NOT NULL,
    data_matricula DATE DEFAULT CURRENT_DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Ativa' NOT NULL CHECK (status IN ('Ativa', 'Concluída', 'Cancelada')), -- RESTRIÇÃO CHECK 4
    valor_pago NUMERIC(10, 2) NOT NULL CHECK (valor_pago >= 0),
    CONSTRAINT fk_matriculas_alunos FOREIGN KEY (id_aluno) 
        REFERENCES alunos(id_aluno) ON DELETE CASCADE,
    CONSTRAINT fk_matriculas_cursos FOREIGN KEY (id_curso) 
        REFERENCES cursos(id_curso) ON DELETE CASCADE
);

/*
TABELA: avaliacoes
Finalidade e objetivo operacional: Guarda o feedback, notas e resenhas concedidas 
pelos alunos aos cursos finalizados ou em andamento.
*/
CREATE TABLE avaliacoes (
    id_avaliacao SERIAL PRIMARY KEY,
    id_matricula INT NOT NULL UNIQUE, -- Cada matrícula só pode gerar 1 avaliação
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5), -- RESTRIÇÃO CHECK 5
    comentario TEXT,
    data_avaliacao DATE DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT fk_avaliacoes_matriculas FOREIGN KEY (id_matricula) 
        REFERENCES matriculas(id_matricula) ON DELETE CASCADE
);


-- ============================================================================
-- MASSA DE DADOS (DML - INSERT)
-- ============================================================================

-- Inserindo Instrutores (5 registros)
INSERT INTO instrutores (nome, email, especialidade, valor_hora_aula, data_admissao) VALUES
('Carlos Eduardo Silva', 'carlos.silva@techlearn.com', 'Banco de Dados', 85.00, '2023-01-15'),
('Mariana Rocha', 'mariana.rocha@techlearn.com', 'Desenvolvimento Web', 95.00, '2023-03-10'),
('Lucas Mendes', 'lucas.mendes@techlearn.com', 'Inteligência Artificial', 120.00, '2024-02-01'),
('Fernanda Costa', 'fernanda.costa@techlearn.com', 'DevOps & Cloud', 110.00, '2024-05-20'),
('Roberto Almeida', 'roberto.almeida@techlearn.com', 'Cibersegurança', 105.00, '2025-01-10');

-- Inserindo Cursos (6 registros)
INSERT INTO cursos (titulo, nivel, preco, carga_horaria, id_instrutor) VALUES
('PostgreSQL Avançado e Otimização', 'Avançado', 299.90, 40, 1),
('Desenvolvimento Fullstack com React e Node.js', 'Intermediário', 349.90, 60, 2),
('Introdução ao Machine Learning com Python', 'Iniciante', 199.90, 30, 3),
('Arquitetura de Nuvem na AWS', 'Avançado', 450.00, 50, 4),
('Fundamentos de Pentest e Segurança', 'Iniciante', 249.90, 35, 5),
('Modelagem de Dados Relacional', 'Iniciante', 149.90, 20, 1);

-- Inserindo Alunos (6 registros)
INSERT INTO alunos (nome, email, cpf, data_nascimento) VALUES
('Ana Clara Souza', 'ana.souza@gmail.com', '111.222.333-01', '1998-05-12'),
('Bruno Carvalho', 'bruno.c@hotmail.com', '222.333.444-02', '1995-09-23'),
('Camila Rodrigues', 'camila.r@outlook.com', '333.444.555-03', '2001-01-30'),
('Diego Martins', 'diego.m@yahoo.com', '444.555.666-04', '1990-11-05'),
('Elena Pires', 'elena.pires@gmail.com', '555.666.777-05', '1997-07-18'),
('Felipe Guedes', 'felipe.g@gmail.com', '666.777.888-06', '2003-03-25');

-- Inserindo Matrículas (8 registros)
INSERT INTO matriculas (id_aluno, id_curso, data_matricula, status, valor_pago) VALUES
(1, 1, '2026-01-10', 'Concluída', 299.90),
(1, 4, '2026-02-15', 'Ativa', 450.00),
(2, 2, '2026-01-20', 'Concluída', 349.90),
(3, 3, '2026-02-01', 'Ativa', 199.90),
(4, 1, '2026-02-10', 'Concluída', 299.90),
(4, 5, '2026-03-01', 'Ativa', 249.90),
(5, 6, '2026-03-05', 'Cancelada', 149.90),
(6, 2, '2026-03-10', 'Ativa', 349.90);

-- Inserindo Avaliações (4 registros para as matrículas concluídas ou ativas)
INSERT INTO avaliacoes (id_matricula, nota, comentario, data_avaliacao) VALUES
(1, 5, 'Excelente curso de PostgreSQL! Conteúdo prático e aprofundado.', '2026-02-01'),
(3, 4, 'Ótima didática na parte de React.', '2026-02-28'),
(5, 5, 'Instrutor domina muito o assunto de banco de dados.', '2026-03-02');


-- ============================================================================
-- CONSULTAS SQL (SELECT com JOIN, GROUP BY e Filtros)
-- ============================================================================

-- Consulta 1: Listar todas as matrículas ativas/concluídas com Nome do Aluno, Título do Curso, Nome do Instrutor e Valor Pago.
SELECT 
    a.nome AS nome_aluno,
    c.titulo AS curso,
    i.nome AS instrutor,
    m.status,
    m.valor_pago
FROM matriculas m
INNER JOIN alunos a ON m.id_aluno = a.id_aluno
INNER JOIN cursos c ON m.id_curso = c.id_curso
INNER JOIN instrutores i ON c.id_instrutor = i.id_instrutor
WHERE m.status IN ('Ativa', 'Concluída')
ORDER BY m.data_matricula DESC;

-- Consulta 2: Total faturado e quantidade de matrículas por nível de curso (Agrupamento com JOIN e GROUP BY).
SELECT 
    c.nivel,
    COUNT(m.id_matricula) AS total_matriculas,
    SUM(m.valor_pago) AS receita_total,
    ROUND(AVG(m.valor_pago), 2) AS ticket_medio
FROM cursos c
LEFT JOIN matriculas m ON c.id_curso = m.id_curso
GROUP BY c.nivel
HAVING COUNT(m.id_matricula) > 0
ORDER BY receita_total DESC;

-- Consulta 3: Média de avaliação de cada curso juntamente com a quantidade de avaliações recebidas.
SELECT 
    c.titulo AS curso,
    ROUND(AVG(av.nota), 2) AS media_nota,
    COUNT(av.id_avaliacao) AS qtd_avaliacoes
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
INNER JOIN avaliacoes av ON m.id_matricula = av.id_matricula
GROUP BY c.titulo
ORDER BY media_nota DESC;

-- =============================================================
-- TRABALHO 02 - FUNCTIONS
-- =============================================================

ALTER TABLE venda ADD COLUMN IF NOT EXISTS venda_comissionado BOOLEAN DEFAULT FALSE;

-- =============================================================
-- FUNCTION 1: Total vendido por funcionário em um período
-- Tipo de retorno: escalar (NUMERIC)
-- =============================================================
CREATE OR REPLACE FUNCTION fn_total_vendas_funcionario(
    p_func_id  INT,
    p_data_ini TIMESTAMP,
    p_data_fim TIMESTAMP
)
RETURNS NUMERIC(12, 2) AS $$
DECLARE
    v_total NUMERIC(12, 2);
BEGIN
    SELECT COALESCE(SUM(venda_total), 0)
      INTO v_total
      FROM venda
     WHERE funcionario_id = p_func_id
       AND venda_data_criacao BETWEEN p_data_ini AND p_data_fim;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- =============================================================
-- FUNCTION 2: Validação de regra de negócio
-- Impede registro de venda para funcionário inexistente ou inativo
-- Tipo de retorno: BOOLEAN (ou exceção)
-- =============================================================
CREATE OR REPLACE FUNCTION fn_valida_funcionario_ativo(p_func_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_ativo BOOLEAN;
BEGIN
    SELECT funcionario_ativo
      INTO v_ativo
      FROM funcionario
     WHERE funcionario_id = p_func_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Funcionário % não existe.', p_func_id;
    END IF;

    IF v_ativo IS NOT TRUE THEN
        RAISE EXCEPTION 'Funcionário % está inativo e não pode registrar vendas.', p_func_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =============================================================
-- FUNCTION 3: Relatório resumido de vendas e comissões por funcionário
-- Tipo de retorno: TABLE (conjunto de linhas)
-- =============================================================
CREATE OR REPLACE FUNCTION fn_relatorio_comissoes(
    p_data_ini TIMESTAMP,
    p_data_fim TIMESTAMP
)
RETURNS TABLE (
    rel_funcionario    TEXT,
    rel_qtd_vendas     BIGINT,
    rel_total_vendas   NUMERIC(12, 2),
    rel_total_comissao NUMERIC(12, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT f.funcionario_nome::TEXT,
           COUNT(v.venda_id),
           COALESCE(SUM(v.venda_total), 0)::NUMERIC(12, 2),
           COALESCE((
               SELECT SUM(c.comissao_valor)
                 FROM comissao c
                WHERE c.funcionario_id = f.funcionario_id
                  AND c.comissao_data_criacao BETWEEN p_data_ini AND p_data_fim
           ), 0)::NUMERIC(12, 2)
      FROM funcionario f
      LEFT JOIN venda v
             ON v.funcionario_id = f.funcionario_id
            AND v.venda_data_criacao BETWEEN p_data_ini AND p_data_fim
     GROUP BY f.funcionario_id, f.funcionario_nome
     ORDER BY 3 DESC;
END;
$$ LANGUAGE plpgsql;

-- =============================================================
-- TESTES DE EXECUÇÃO
-- =============================================================

-- Function 1
SELECT fn_total_vendas_funcionario(1, '2026-01-01 00:00:00', '2026-12-31 23:59:59');

-- Function 2 (retorna TRUE ou gera erro para funcionário inativo/inexistente)
SELECT fn_valida_funcionario_ativo(1);
SELECT fn_valida_funcionario_ativo(99);

-- Function 3
SELECT * FROM fn_relatorio_comissoes('2026-01-01 00:00:00', '2026-12-31 23:59:59');
