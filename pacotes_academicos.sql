-- Pacote PKG_ALUNO
-- -----------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_ALUNO AS

    -- Procedure de exclusão de aluno
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER);

    -- Cursor de listagem de alunos maiores de 18 anos
    CURSOR c_alunos_maiores_18 IS
        SELECT nome, data_nascimento
        FROM alunos
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;

    -- Cursor com filtro por curso
    CURSOR c_alunos_por_curso(p_id_curso IN NUMBER) IS
        SELECT a.nome
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_curso = p_id_curso;

END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS

    -- Implementação da procedure de exclusão de aluno e matrículas
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        -- Exclui todas as matrículas do aluno
        DELETE FROM matriculas WHERE id_aluno = p_id_aluno;

        -- Exclui o aluno da tabela de alunos
        DELETE FROM alunos WHERE id_aluno = p_id_aluno;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END excluir_aluno;

END PKG_ALUNO;
/

-- Pacote PKG_DISCIPLINA
-- -----------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS

    -- Procedure de cadastro de disciplina
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);

    -- Cursor para total de alunos por disciplina
    CURSOR c_total_alunos_por_disciplina IS
        SELECT d.nome, COUNT(m.id_aluno) AS total_alunos
        FROM disciplinas d
        LEFT JOIN matriculas m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.id_disciplina, d.nome
        HAVING COUNT(m.id_aluno) > 10;

    -- Cursor para média de idade por disciplina
    CURSOR c_media_idade_por_disciplina(p_id_disciplina IN NUMBER) IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;

    -- Procedure para listar alunos de uma disciplina
    PROCEDURE listar_alunos_disciplina(p_id_disciplina IN NUMBER);

END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS

    -- Implementação da procedure para cadastrar uma nova disciplina
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        INSERT INTO disciplinas (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END cadastrar_disciplina;

    -- Implementação da procedure para listar alunos de uma disciplina
    PROCEDURE listar_alunos_disciplina(p_id_disciplina IN NUMBER) IS
        v_nome alunos.nome%TYPE;
    BEGIN
        FOR aluno IN
            (SELECT a.nome
             FROM alunos a
             JOIN matriculas m ON a.id_aluno = m.id_aluno
             WHERE m.id_disciplina = p_id_disciplina) LOOP
            v_nome := aluno.nome;
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || v_nome);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END listar_alunos_disciplina;

END PKG_DISCIPLINA;
/

-- Pacote PKG_PROFESSOR
-- -----------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS

    -- Cursor para total de turmas por professor
    CURSOR c_total_turmas_por_professor IS
        SELECT p.nome, COUNT(t.id_turma) AS total_turmas
        FROM professores p
        JOIN turmas t ON p.id_professor = t.id_professor
        GROUP BY p.id_professor, p.nome
        HAVING COUNT(t.id_turma) > 1;

    -- Function para total de turmas de um professor
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER;

    -- Function para professor de uma disciplina
    FUNCTION professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;

END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS

    -- Implementação da function para calcular o total de turmas de um professor
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(t.id_turma)
        INTO v_total
        FROM turmas t
        WHERE t.id_professor = p_id_professor;

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END total_turmas_professor;

    -- Implementação da function para encontrar o professor de uma disciplina
    FUNCTION professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor professores.nome%TYPE;
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM professores p
        JOIN turmas t ON p.id_professor = t.id_professor
        WHERE t.id_disciplina = p_id_disciplina
        AND ROWNUM = 1;

        RETURN v_nome_professor;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Professor não encontrado';
    END professor_disciplina;

END PKG_PROFESSOR;
/
