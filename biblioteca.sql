CREATE TABLE autor (
    nome varchar(40),
    id_autor SERIAL PRIMARY KEY
);

CREATE TABLE livro (
    Titulo varchar(40),
    id_livro SERIAL PRIMARY KEY,
    id_autor int REFERENCES autor (id_autor)
    on update no action on delete cascade 
    );

CREATE TABLE usuario (
    nome varchar(40),
    email varchar(40) unique,
    id_usuario SERIAL PRIMARY KEY
);

CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data date,
    data_devolucao date,
    data_emprestimo date,
    valor_emprestimo numeric,
    id_livro int REFERENCES  livro (id_livro),
    id_usuario int REFERENCES usuario (id_usuario)
);

INSERT INTO autor (nome) VALUES ('Machado de Assis'), ('Clarice Lispector');

-- Livros
INSERT INTO livro (titulo, id_autor) VALUES 
('Dom Casmurro', 1),
('Memórias Póstumas de Brás Cubas', 1),
('A Hora da Estrela', 2);

-- Usuários
INSERT INTO usuario (nome, email) VALUES 
('João Silva', 'joao@email.com'),
('Maria Souza', 'maria@email.com');

-- Empréstimos
INSERT INTO emprestimo (data_emprestimo, data_devolucao, valor_emprestimo, id_usuario, id_livro) VALUES
('2026-03-01', '2026-03-10', 15.00, 1, 1),
('2026-03-05', NULL, 20.00, 2, 3);

INSERT INTO emprestimo (data_emprestimo, data_devolucao, valor_emprestimo, id_usuario, id_livro) VALUES
('2026-03-01', '2026-03-10', 35.00, 2, 1)



-- ex: 1 - livros emprestados 
select  l.Titulo from livro l
inner join emprestimo e 
on l.id_livro = e.id_livro;


-- ex: 2 - livros nao emprestados 
select  l.Titulo from livro l
where l.id_livro  in
(select l.id_livro from emprestimo);
-- dom carmurro,  memorias póstumas de brás cubas ,a hora da estrela 


-- ex: 3 -quantidade de livros emprestados
select count (id_emprestimo) from emprestimo 


-- ex: 4 - quantidade de livro que cada autor tem 
select a.nome, count( a.id_autor) from autor a 
inner join livro l 
on a.id_autor = l.id_autor group by a.nome  


-- ex: 5 - valor dos livros do mais caro para o mais barato
select valor_emprestimo,  l.Titulo  from emprestimo e
inner join livro l 
on l.id_livro = e.id_livro group by e.valor_emprestimo , l.titulo 




-- alteração para resolver o ex : 6
alter table emprestimo drop constraint emprestimo_id_livro_fkey;

alter table emprestimo
add constraint emprestimo_id_livro_fkey
foreign key (id_livro) references livro (id_livro)
on delete cascade;

alter table livro drop constraint livro_id_autor_fkey

alter table livro
add constraint livro_id_autor_fkey
foreign key (id_autor) references autor (id_autor)
on delete cascade;

-- ex: 6 - apagar um autor  em cascata

delete from autor where id_autor=1

select a.nome, l.titulo from autor a
inner join livro l on l.id_autor = a.id_autor





-- ex: 7 - total arrecadado em emprestimo
select l.titulo, sum(e.valor_emprestimo ) from livro l
inner join emprestimo e 
on l.id_livro = e.id_livro
group by l.titulo 














