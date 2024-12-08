# Pacotes PL/SQL - Sistema Acadêmico

Este repositório contém um conjunto de pacotes em PL/SQL que implementam operações relacionadas às entidades **Aluno**, **Disciplina** e **Professor**, com o objetivo de demonstrar o uso de procedures, functions e cursores em Oracle.

## Estrutura dos Pacotes

### 1. **PKG_ALUNO**
- **Procedure**: Exclui um aluno e todas as suas matrículas.
- **Cursores**:
  - Lista alunos com idade superior a 18 anos.
  - Lista alunos matriculados em um curso específico.

### 2. **PKG_DISCIPLINA**
- **Procedure**: Cadastra uma nova disciplina.
- **Cursores**:
  - Lista o número de alunos matriculados em cada disciplina (exibe apenas disciplinas com mais de 10 alunos).
  - Calcula a média de idade dos alunos matriculados em uma disciplina específica.
- **Procedure**: Exibe a lista de alunos matriculados em uma disciplina específica.

### 3. **PKG_PROFESSOR**
- **Cursores**:
  - Lista professores responsáveis por mais de uma turma.
- **Funções**:
  - Retorna o total de turmas de um professor.
  - Retorna o nome do professor responsável por uma disciplina.

## Instruções para Executar

1. **Preparação do Banco de Dados**: As tabelas necessárias devem estar criadas antes de executar os pacotes. As tabelas `alunos`, `disciplinas`, `matriculas`, `professores` e `turmas` são necessárias.

2. **Execução do Script**: 
   - Copie o conteúdo do arquivo `pacotes_academicos.sql`.
   - Abra o SQL*Plus ou qualquer ferramenta de administração Oracle (SQL Developer, TOAD).
   - Conecte-se ao banco de dados.
   - Cole o conteúdo do arquivo no SQL*Plus ou carregue o arquivo `.sql` e execute-o.
   
3. **Testando os Pacotes**:
   - Após executar os pacotes, você pode testar as procedures, funções e cursores com comandos `EXEC` e consultas SQL.

## Exemplo de Uso

### Excluir Aluno
```sql
EXEC PKG_ALUNO.excluir_aluno(1);
