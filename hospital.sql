create type turno as enum ('manhã','tarde','noite');
create type cobertura_plano as enum ('regional','nacional');
create type status_atendimento as enum ('realizado','cancelado','agendado');
create type tipo_atendimento as enum ('emergência','revisão','consulta');
create type status_ala as enum ('ocupado','livre','manut');
create type status_leito as enum ('ocupado','livre','manut');
create type tipo_ala as enum ('uti','pediatria','enfermaria','quarentena','outros');
create type resultado_exame as enum ('normal','alterado','crítico');
create type tipo_exame as enum ('sanguíneo','imagem','psicológico', 'outros');
create type status_faturamento as enum ('pago','pendente','cancelado','em análise');
create type tipo_lab as enum ('interno','externo');
create type tipo_faturamento as enum ('consulta','exame','internação');
CREATE TYPE cargo_enfermeiro AS ENUM ('enfermeiro', 'enfermeiro chefe');

CREATE TABLE hospital (
	id_hospital serial primary key,
    CNPJ numeric unique,
    Nome varchar not null,
    Endereco varchar not null
);

CREATE TABLE ala (
    id_ala serial PRIMARY KEY,
    nome varchar not null,
    status_ala status_ala,
    tipo_ala tipo_ala,
    id_hospital integer not null,
    foreign key (id_hospital) references hospital(id_hospital) 
    on delete cascade ON UPDATE CASCADE
);

CREATE TABLE plano_de_saude (
    id_plano serial PRIMARY key not null,
    nome varchar not null,
    operadora varchar,
    cobertura_plano cobertura_plano,
    telefone numeric,
	id_hospital integer not null,
    FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

CREATE TABLE paciente (
    id_paciente serial PRIMARY KEY,
    nome varchar(50) not null,
    cpf numeric not null unique,
    endereco varchar(100),
    data_nascimento numeric,
    email varchar(60) unique not null,
	id_leito integer,
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE medico (
    CRM serial PRIMARY KEY,
    nome varchar(50) not null,
    email varchar(60) not null unique,
    especialidade varchar(60) not null,
    id_ala integer not null,
    id_hospital integer not null,
    foreign key (id_ala) references ala (id_ala),
    foreign key (id_hospital) references hospital(id_hospital)
    on delete cascade ON UPDATE CASCADE
);

CREATE TABLE enfermeira (
    CRE serial PRIMARY KEY,
    nome varchar(50) not null,
    email varchar(60) not null unique,
    turno turno,
    id_ala integer not null,
    foreign key (id_ala) references ala (id_ala)
);

CREATE TABLE leito (
    id_leito serial PRIMARY KEY,
    status_leito status_leito,
    id_ala integer not null,
    foreign key (id_ala) references ala (id_ala)
    on delete cascade ON UPDATE CASCADE
);

CREATE TABLE atendimento (
    id_atendimento serial PRIMARY KEY,
    tipo_atendimento tipo_atendimento,
    data date ,
    status_atendimento status_atendimento,
    registro_atendimento varchar(60),
    CRM integer not null,
    id_pesquisa_satisfacao integer not null,
    id_paciente integer not null,
    foreign key (id_pesquisa_satisfacao) references pesquisa_satisfacao (id_pesquisa_satisfacao),
    foreign key (id_paciente) references paciente (id_paciente),
    foreign key (CRM) references medico (CRM)
    on delete cascade ON UPDATE CASCADE
);

CREATE TABLE medicamento (
    id_medicamento serial PRIMARY KEY,
    nome varchar(60) not null,
    composicao varchar(100)
);

CREATE TABLE faturamento (
    id_internacao serial PRIMARY KEY,
    data_entrada date,
    data_saida date,
    data_emisao date,
    data_vencimento date,
    status_faturamento status_faturamento,
    id_paciente integer not null,
    foreign key (id_paciente) references paciente (id_paciente)
);

CREATE TABLE exame (
    id_exame serial PRIMARY KEY,
    data_solicitacao date,
    data_resultado date,
    tipo_exame tipo_exame,
    custo smallint,
    descricao_detalhada varchar(100) not null,
    resultado_exame resultado_exame,
    anexo_laudo bytea,
    id_paciente integer not null,
    id_laboratorio integer not null,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_laboratorio) REFERENCES laboratorio(id_laboratorio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE laboratorio (
    id_laboratorio serial PRIMARY KEY,
    tipo_lab tipo_lab,
    nome varchar(60),
    endereco varchar(100)
);

CREATE TABLE pesquisa_satisfacao (
    id_pesquisa_satisfacao serial PRIMARY KEY,
    data_resposta date,
    nota_geral numeric not null,
    comentario varchar(150),
    recomendacao boolean,
    tempo_espera_avaliacao numeric
);

CREATE TABLE medicamento_prescricao (
    id_medicamento_prescricao serial PRIMARY KEY,
    dosagem numeric,
    dias_medicacao numeric,
    descrico varchar(200),
    id_paciente integer not null,
    id_medicamento integer not null,
    CRM integer not null,
	foreign key (id_paciente) references paciente (id_paciente),
	foreign key (CRM) references medico (CRM),
	foreign key (id_medicamento) references medicamento (id_medicamento)
);

CREATE TABLE solicita (
	id_solicitacao serial primary key,
	CRM integer not null,
	id_exame integer not null,
    foreign key (CRM) references medico (CRM),
    foreign key (id_exame) references exame (id_exame)
);


CREATE TABLE paciente_plano (
    id_paciente integer not null,
    id_plano    integer not null,
    PRIMARY KEY (id_paciente, id_plano),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_plano)    REFERENCES plano_de_saude(id_plano)
);

create table internacao (
	id_internacao serial primary key,
	data_entrada numeric,
	data_saida numeric,
	id_paciente integer not null,
	id_leito integer not null,
	FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
	FOREIGN KEY (id_leito) REFERENCES leito(id_leito) 
)

alter table faturamento add column preco_faturamento numeric(10,2); 

alter table faturamento add column valor_total numeric(10,2)

alter table faturamento add column tipo_faturamento tipo_faturamento; -- enum

alter table faturamento add column id_plano integer;

alter table enfermeira add column cargo_enfermeiro cargo_enfermeiro

alter table medico add column telefone varchar(13);

UPDATE medico SET telefone = CASE CRM
    WHEN 1  THEN 1198765432
    WHEN 2  THEN 1197654321
    WHEN 3  THEN 1196543210
    WHEN 4  THEN 1195432109
    WHEN 5  THEN 1194321098
    WHEN 6  THEN 1193210987
    WHEN 7  THEN 1192109876
    WHEN 8  THEN 1191098765
    WHEN 9  THEN 1190987654
    WHEN 10 THEN 1189876543
END;

ALTER TABLE faturamento ADD CONSTRAINT fk_fat_plano
    FOREIGN KEY (id_plano) REFERENCES plano_de_saude(id_plano);


INSERT INTO hospital (CNPJ, Nome, Endereco) VALUES
(12345678000190, 'Hospital São Lucas', 'Rua das Flores, 100, São Paulo - SP');
 
INSERT INTO ala (nome, status_ala, tipo_ala, id_hospital) VALUES
('UTI Adulto',       'ocupado', 'uti',         1),
('Pediatria',        'ocupado', 'pediatria',   1),
('Enfermaria Geral', 'ocupado', 'enfermaria',  1),
('Quarentena',       'livre',   'quarentena',  1),
('Outros Serviços',  'livre',   'outros',      1);


INSERT INTO leito (status_leito, id_ala) VALUES

('ocupado', 1), ('ocupado', 1), ('livre', 1), ('livre', 1),

('ocupado', 2), ('ocupado', 2), ('livre', 2), ('livre', 2),

('ocupado', 3), ('ocupado', 3), ('ocupado', 3), ('livre', 3),

('ocupado', 4), ('livre', 4), ('livre', 4), ('livre', 4),

('livre', 5), ('livre', 5), ('livre', 5), ('livre', 5);

 
 INSERT INTO plano_de_saude (nome, operadora, cobertura_plano, telefone, id_hospital) VALUES
('Unimed Básico',    'Unimed',     'regional',  1132001000, 1),
('Unimed Plus',      'Unimed',     'nacional',  1132001001, 1),
('Amil Premium',     'Amil',       'nacional',  1133002000, 1),
('SulAmérica Saúde', 'SulAmérica', 'regional',  1134003000, 1),
('Bradesco Saúde',   'Bradesco',   'nacional',  1135004000, 1);

INSERT INTO laboratorio (tipo_lab, nome, endereco) VALUES
('interno', 'Lab Central HSL',       'Rua das Flores, 100 - Bloco B'),
('interno', 'Lab de Imagem HSL',     'Rua das Flores, 100 - Bloco C'),
('externo', 'Fleury Medicina',       'Av. Paulista, 500, São Paulo'),
('externo', 'DASA Diagnósticos',     'Rua Augusta, 200, São Paulo'),
('externo', 'Hermes Pardini',        'Av. Brasil, 700, São Paulo');

INSERT INTO medico (nome, email, especialidade, id_ala, id_hospital) VALUES
('Dr. Carlos Mendes',    'carlos.mendes@hsl.com',    'Cardiologia',    1, 1),
('Dra. Ana Souza',       'ana.souza@hsl.com',        'Cardiologia',    1, 1),
('Dr. Roberto Lima',     'roberto.lima@hsl.com',     'Pediatria',      2, 1),
('Dra. Fernanda Costa',  'fernanda.costa@hsl.com',   'Clínica Geral',  3, 1),
('Dr. Paulo Oliveira',   'paulo.oliveira@hsl.com',   'Ortopedia',      3, 1),
('Dra. Juliana Matos',   'juliana.matos@hsl.com',    'Neurologia',     1, 1),
('Dr. Marcos Pereira',   'marcos.pereira@hsl.com',   'Cardiologia',    1, 1),
('Dra. Camila Rocha',    'camila.rocha@hsl.com',     'Ginecologia',    3, 1),
('Dr. Eduardo Gomes',    'eduardo.gomes@hsl.com',    'Clínica Geral',  3, 1),
('Dra. Patrícia Nunes',  'patricia.nunes@hsl.com',   'Infectologia',   4, 1);

INSERT INTO enfermeira (nome, email, turno, id_ala) VALUES

('Enf. Beatriz Alves',    'beatriz.alves@hsl.com',    'manhã',  1),
('Enf. Rafael Torres',    'rafael.torres@hsl.com',    'tarde',  1),
('Enf. Larissa Moura',    'larissa.moura@hsl.com',    'noite',  1),

('Enf. Thiago Barbosa',   'thiago.barbosa@hsl.com',   'manhã',  2),
('Enf. Priscila Santos',  'priscila.santos@hsl.com',  'tarde',  2),
('Enf. Gabriel Ferreira', 'gabriel.ferreira@hsl.com', 'noite',  2),

('Enf. Vanessa Ribeiro',  'vanessa.ribeiro@hsl.com',  'manhã',  3),
('Enf. Diego Cardoso',    'diego.cardoso@hsl.com',    'tarde',  3),
('Enf. Isabela Martins',  'isabela.martins@hsl.com',  'noite',  3),

('Enf. Rodrigo Castro',   'rodrigo.castro@hsl.com',   'manhã',  4),
('Enf. Amanda Peixoto',   'amanda.peixoto@hsl.com',   'tarde',  4),

('Enf. Leandro Queiroz',  'leandro.queiroz@hsl.com',  'manhã',  5),
('Enf. Natália Fonseca',  'natalia.fonseca@hsl.com',  'tarde',  5),
('Enf. Bruno Cavalcante', 'bruno.cavalcante@hsl.com', 'noite',  5),
('Enf. Mônica Teixeira',  'monica.teixeira@hsl.com',  'noite',  3);

INSERT INTO paciente (nome, cpf, endereco, data_nascimento, email, id_leito) VALUES
('João Silva',         11122233344, 'Rua A, 10, SP', 19800315, 'joao.silva@email.com',        1),
('Maria Oliveira',     22233344455, 'Rua B, 20, SP', 19920720, 'maria.oliveira@email.com',    2),
('Pedro Santos',       33344455566, 'Rua C, 30, SP', 19751105, 'pedro.santos@email.com',      3),
('Ana Costa',          44455566677, 'Rua D, 40, SP', 20010410, 'ana.costa@email.com',          5),
('Lucas Ferreira',     55566677788, 'Rua E, 50, SP', 19881222, 'lucas.ferreira@email.com',    6),
('Julia Lima',         66677788899, 'Rua F, 60, SP', 19950803, 'julia.lima@email.com',         9),
('Carlos Souza',       77788899900, 'Rua G, 70, SP', 19701230, 'carlos.souza@email.com',      10),
('Fernanda Rocha',     88899900011, 'Rua H, 80, SP', 19830617, 'fernanda.rocha@email.com',    11),
('Rodrigo Matos',      99900011122, 'Rua I, 90, SP', 20050920, 'rodrigo.matos@email.com',     13),
('Camila Pereira',     10011022233, 'Rua J, 100, SP',19900214, 'camila.pereira@email.com',    NULL),
('Bruno Alves',        10111122344, 'Rua K, 110, SP',19851118, 'bruno.alves@email.com',       NULL),
('Patrícia Neves',     10211222455, 'Rua L, 120, SP',19780425, 'patricia.neves@email.com',    NULL),
('Thiago Barbosa',     10311322566, 'Rua M, 130, SP',19930712, 'thiago.barbosa@email.com',    NULL),
('Larissa Moura',      10411422677, 'Rua N, 140, SP',20000530, 'larissa.moura2@email.com',    NULL),
('Rafael Torres',      10511522788, 'Rua O, 150, SP',19871009, 'rafael.torres2@email.com',    NULL),
('Vanessa Ribeiro',    10611622899, 'Rua P, 160, SP',19720315, 'vanessa.ribeiro2@email.com',  NULL),
('Diego Cardoso',      10711722900, 'Rua Q, 170, SP',19961127, 'diego.cardoso2@email.com',    NULL),
('Isabela Martins',    10811823011, 'Rua R, 180, SP',20030806, 'isabela.martins2@email.com',  NULL),
('Eduardo Gomes',      10911923122, 'Rua S, 190, SP',19810201, 'eduardo.gomes2@email.com',    NULL),
('Amanda Peixoto',     11012023233, 'Rua T, 200, SP',19990418, 'amanda.peixoto2@email.com',   NULL);


INSERT INTO pesquisa_satisfacao (data_resposta, nota_geral, comentario, recomendacao, tempo_espera_avaliacao) VALUES
('2026-01-10', 9,  'Ótimo atendimento, equipe muito atenciosa.',       true,  15),
('2026-01-15', 7,  'Bom atendimento, mas espera um pouco longa.',      true,  40),
('2026-01-20', 10, 'Excelente! Recomendo a todos.',                    true,  10),
('2026-01-25', 6,  'Atendimento razoável, falta organização.',         false, 60),
('2026-02-02', 8,  'Equipe competente e gentil.',                      true,  20),
('2026-02-10', 5,  'Muita demora no atendimento.',                     false, 90),
('2026-02-14', 9,  'Médico muito atencioso e explicou tudo bem.',      true,  18),
('2026-02-20', 7,  'Ambiente limpo, mas faltam recursos.',             true,  35),
('2026-03-01', 10, 'Perfeito em todos os aspectos.',                   true,  5),
('2026-03-05', 8,  'Gostei bastante, voltarei se precisar.',           true,  22),
('2026-03-08', 6,  'Poderia melhorar a comunicação.',                  false, 50),
('2026-03-10', 9,  'Muito bom, equipe de enfermagem excelente.',       true,  12),
('2026-03-12', 7,  'Atendimento ok, nada de excepcional.',             true,  30),
('2026-03-15', 4,  'Espera absurda, fui mal atendido.',                false, 120),
('2026-03-18', 10, 'Melhor hospital que já fui!',                      true,  8),
('2026-03-20', 8,  'Profissionais qualificados.',                      true,  25),
('2026-03-22', 7,  'Satisfeito com o resultado do exame.',             true,  33),
('2026-03-24', 9,  'Consulta rápida e eficiente.',                     true,  14),
('2026-03-25', 6,  'Estrutura boa mas falta estacionamento.',          true,  45),
('2026-03-26', 8,  'Recomendo, equipe dedicada.',                      true,  20);



INSERT INTO atendimento (tipo_atendimento, data, status_atendimento, registro_atendimento, CRM, id_pesquisa_satisfacao, id_paciente) VALUES

('consulta',   '2026-03-01', 'realizado', 'ATD-001', 1,  1,  1),
('consulta',   '2026-03-02', 'realizado', 'ATD-002', 2,  2,  2),
('emergência', '2026-03-03', 'realizado', 'ATD-003', 1,  3,  3),
('revisão',    '2026-03-04', 'realizado', 'ATD-004', 3,  4,  4),
('consulta',   '2026-03-05', 'realizado', 'ATD-005', 4,  5,  5),
('emergência', '2026-03-06', 'realizado', 'ATD-006', 7,  6,  6),
('consulta',   '2026-03-07', 'realizado', 'ATD-007', 7,  7,  7),
('revisão',    '2026-03-08', 'realizado', 'ATD-008', 1,  8,  8),
('consulta',   '2026-03-10', 'realizado', 'ATD-009', 2,  9,  9),
('consulta',   '2026-03-11', 'realizado', 'ATD-010', 9,  10, 10),
('emergência', '2026-03-12', 'realizado', 'ATD-011', 9,  11, 11),
('revisão',    '2026-03-13', 'realizado', 'ATD-012', 6,  12, 12),
('consulta',   '2026-03-14', 'realizado', 'ATD-013', 5,  13, 13),
('consulta',   '2026-03-15', 'realizado', 'ATD-014', 4,  14, 14),
('revisão',    '2026-03-16', 'realizado', 'ATD-015', 8,  15, 15),
('consulta',   '2026-03-17', 'realizado', 'ATD-016', 10, 16, 16),
('emergência', '2026-03-18', 'realizado', 'ATD-017', 1,  17, 17),
('consulta',   '2026-03-19', 'realizado', 'ATD-018', 7,  18, 18),
('revisão',    '2026-03-20', 'realizado', 'ATD-019', 2,  19, 19),
('consulta',   '2026-03-21', 'realizado', 'ATD-020', 3,  20, 20),

('consulta',   '2026-02-05', 'realizado', 'ATD-021', 1,  1,  2),
('emergência', '2026-02-10', 'realizado', 'ATD-022', 4,  2,  4),
('revisão',    '2026-02-15', 'realizado', 'ATD-023', 7,  3,  6),
('consulta',   '2026-02-20', 'realizado', 'ATD-024', 9,  4,  8),
('consulta',   '2026-02-25', 'cancelado', 'ATD-025', 2,  5,  10),

('consulta',   '2026-01-08', 'realizado', 'ATD-026', 5,  6,  12),
('revisão',    '2026-01-12', 'realizado', 'ATD-027', 6,  7,  14),
('emergência', '2026-01-18', 'realizado', 'ATD-028', 8,  8,  16),
('consulta',   '2026-01-22', 'realizado', 'ATD-029', 10, 9,  18),
('revisão',    '2026-01-28', 'realizado', 'ATD-030', 3,  10, 20);

INSERT INTO medicamento (nome, composicao) VALUES
('Dipirona 500mg',      'Dipirona sódica 500mg'),
('Amoxicilina 500mg',   'Amoxicilina tri-hidratada 500mg'),
('Omeprazol 20mg',      'Omeprazol 20mg'),
('Losartana 50mg',      'Losartana potássica 50mg'),
('Atorvastatina 20mg',  'Atorvastatina cálcica 20mg'),
('Metformina 850mg',    'Cloridrato de metformina 850mg'),
('Paracetamol 750mg',   'Paracetamol 750mg'),
('Captopril 25mg',      'Captopril 25mg'),
('Azitromicina 500mg',  'Azitromicina di-hidratada 500mg'),
('Ibuprofeno 600mg',    'Ibuprofeno 600mg');


insert INTO medicamento_prescricao (dosagem, dias_medicacao, descrico, id_paciente, id_medicamento, CRM) VALUES
(500,  7,  'Tomar 1 comprimido a cada 6h em caso de dor',      1,  1,  1),
(500,  10, 'Tomar 1 comprimido a cada 8h com água',            1,  2,  1),
(20,   30, 'Tomar 1 comprimido em jejum pela manhã',           2,  3,  4),
(50,   60, 'Tomar 1 comprimido por dia no almoço',             3,  4,  2),
(20,   30, 'Tomar 1 comprimido por dia à noite',               3,  5,  2),
(850,  90, 'Tomar 1 comprimido com as refeições',              4,  6,  3),
(750,  5,  'Tomar 1 comprimido a cada 8h em caso de febre',    5,  7,  4),
(25,   30, 'Tomar 1 comprimido a cada 12h',                    6,  8,  1),
(500,  5,  'Tomar 1 comprimido por dia pelo período indicado', 7,  9,  7),
(600,  7,  'Tomar 1 comprimido a cada 8h com alimentos',       8,  10, 5),
(500,  7,  'Tomar 1 comprimido a cada 6h em caso de dor',      9,  1,  7),
(500,  10, 'Tomar 1 comprimido a cada 8h com água',            10, 2,  9),
(20,   30, 'Tomar 1 comprimido em jejum pela manhã',           11, 3,  4),
(50,   60, 'Tomar 1 comprimido por dia no almoço',             12, 4,  2),
(750,  5,  'Tomar 1 comprimido a cada 8h em caso de febre',    13, 7,  9),
(25,   30, 'Tomar 1 comprimido a cada 12h',                    14, 8,  1),
(500,  5,  'Tomar 1 comprimido por dia pelo período indicado', 15, 9,  7),
(600,  7,  'Tomar 1 comprimido a cada 8h com alimentos',       16, 10, 5),
(500,  7,  'Tomar 1 comprimido a cada 6h em caso de dor',      17, 1,  1),
(20,   30, 'Tomar 1 comprimido em jejum pela manhã',           18, 3,  4);
 
 -- EXAMES (25)

INSERT INTO exame (data_solicitacao, data_resultado, tipo_exame, custo, descricao_detalhada, resultado_exame, id_paciente, id_laboratorio) VALUES

('2026-01-05', '2026-01-06', 'sanguíneo', 80,  'Hemograma completo',               'normal',   1,  1),
('2026-01-10', '2026-01-11', 'imagem',    200, 'Raio-X tórax',                     'normal',   2,  2),
('2026-01-15', '2026-01-16', 'sanguíneo', 90,  'Glicemia de jejum',                'alterado', 3,  1),
('2026-01-20', '2026-01-21', 'imagem',    350, 'Tomografia de crânio',             'normal',   4,  2),
('2026-02-03', '2026-02-04', 'sanguíneo', 75,  'Lipidograma',                      'alterado', 5,  1),
('2026-02-08', '2026-02-09', 'imagem',    180, 'Ultrassom abdominal',              'normal',   6,  2),
('2026-02-12', '2026-02-13', 'psicológico',150,'Avaliação de ansiedade',           'alterado', 7,  3),
('2026-02-18', '2026-02-19', 'sanguíneo', 85,  'TSH e T4 livre',                   'normal',   8,  1),
('2026-02-22', '2026-02-23', 'outros',    120, 'Eletrocardiograma em repouso',     'normal',   9,  4),
('2026-03-01', '2026-03-02', 'sanguíneo', 80,  'Hemograma completo',               'crítico',  10, 1),
('2026-03-05', '2026-03-06', 'imagem',    200, 'Raio-X tórax',                     'normal',   11, 2),
('2026-03-08', '2026-03-09', 'sanguíneo', 90,  'Coagulograma',                     'alterado', 12, 3),
('2026-03-10', '2026-03-11', 'outros',    130, 'Espirometria',                     'normal',   13, 5),
('2026-03-12', '2026-03-13', 'imagem',    350, 'Ressonância magnética coluna',     'alterado', 14, 2),
('2026-03-14', '2026-03-15', 'sanguíneo', 80,  'Hemograma completo',               'normal',   15, 1),

('2026-03-20', NULL, 'sanguíneo', 80,  'Hemograma completo urgente',               NULL,       16, 1),
('2026-03-21', NULL, 'imagem',    200, 'Raio-X tórax urgente',                     NULL,       17, 2),
('2026-03-22', NULL, 'sanguíneo', 90,  'PCR e VHS inflamatório',                   NULL,       18, 3),
('2026-03-23', NULL, 'psicológico',150,'Avaliação neuropsicológica',               NULL,       19, 4),
('2026-03-24', NULL, 'outros',    120, 'ECG de esforço',                           NULL,       20, 5),
('2026-03-24', NULL, 'sanguíneo', 85,  'Função renal (creatinina, ureia)',         NULL,       1,  1),
('2026-03-25', NULL, 'imagem',    180, 'Ultrassom pélvico',                        NULL,       2,  2),
('2026-03-25', NULL, 'sanguíneo', 75,  'Perfil hormonal',                         NULL,       3,  3),
('2026-03-26', NULL, 'outros',    130, 'Endoscopia digestiva alta',                NULL,       4,  4),
('2026-03-26', NULL, 'imagem',    350, 'Tomografia de abdômen com contraste',      NULL,       5,  5);
 
 

-- SOLICITAÇÕES DE EXAMES (relaciona médico ao exame)

INSERT INTO solicita (CRM, id_exame) VALUES
(1, 51), (2, 52), (4, 53), (2, 54), (1, 55),
(6, 56), (6, 57), (1, 58), (7, 59), (9, 60),
(4, 61), (2, 62), (5, 63), (5, 64), (4, 65),
(9, 66), (1, 67), (7, 68), (6, 69), (9, 70),
(1, 71), (8, 72), (2, 73), (10,74), (3, 75);


INSERT INTO faturamento (data_entrada, data_saida, data_emisao, data_vencimento, status_faturamento, id_paciente) VALUES

('2026-03-01', NULL,         '2026-03-01', '2026-04-01', 'pendente',   1), 
('2026-03-05', NULL,         '2026-03-05', '2026-04-05', 'pendente',   2),  
('2026-03-08', NULL,         '2026-03-08', '2026-04-08', 'pendente',   3), 
('2026-03-20', NULL,         '2026-03-20', '2026-04-20', 'pendente',   4),  
('2026-03-22', NULL,         '2026-03-22', '2026-04-22', 'pendente',   5),  
('2026-03-10', NULL,         '2026-03-10', '2026-04-10', 'pendente',   6),  
('2026-03-05', NULL,         '2026-03-05', '2026-04-05', 'pendente',   7),  
('2026-03-12', NULL,         '2026-03-12', '2026-04-12', 'pendente',   8),  
('2026-03-15', NULL,         '2026-03-15', '2026-04-15', 'pendente',   9),  
('2026-01-10', '2026-01-20', '2026-01-20', '2026-02-20', 'pago',      10),
('2026-01-15', '2026-01-25', '2026-01-25', '2026-02-25', 'pago',      11),
('2026-02-01', '2026-02-10', '2026-02-10', '2026-03-10', 'pago',      12),
('2026-02-05', '2026-02-15', '2026-02-15', '2026-03-15', 'pago',      13),
('2026-02-10', '2026-02-20', '2026-02-20', '2026-03-20', 'pago',      14),
('2026-03-01', '2026-03-10', '2026-03-10', '2026-04-10', 'pago',      15),
('2026-03-05', '2026-03-18', '2026-03-18', '2026-04-18', 'pago',      16),
('2026-03-08', '2026-03-20', '2026-03-20', '2026-04-20', 'pago',      17),
('2026-03-10', '2026-03-22', '2026-03-22', '2026-04-22', 'pago',      18),
('2026-03-12', '2026-03-25', '2026-03-25', '2026-04-25', 'pago',      19),
('2026-03-15', '2026-03-26', '2026-03-26', '2026-04-26', 'pago',      20);


INSERT INTO paciente_plano (id_paciente, id_plano) VALUES
(1,  1), -- Unimed Básico
(2,  1), -- Unimed Básico
(3,  2), -- Unimed Plus
(4,  2), -- Unimed Plus
(5,  3), -- Amil
(6,  3), -- Amil
(7,  4), -- SulAmérica
(8,  4), -- SulAmérica
(9,  5), -- Bradesco
(10, 5), -- Bradesco
(11, 1), -- Unimed Básico
(12, 2), -- Unimed Plus
(13, 3), -- Amil
(14, 4), -- SulAmérica
(15, 5), -- Bradesco
(16, 1), -- Unimed Básico
(17, 2), -- Unimed Plus
(18, 3), -- Amil
(19, 4), -- SulAmérica
(20, 5); -- Bradesco


INSERT INTO internacao (data_entrada, data_saida, id_paciente, id_leito) VALUES

(20260301, NULL,     1,  1),   
(20260305, NULL,     2,  2),   
(20260308, NULL,     3,  3),   
(20260320, NULL,     4,  5),   
(20260322, NULL,     5,  6),   
(20260310, NULL,     6,  9),   
(20260305, NULL,     7,  10),  
(20260312, NULL,     8,  11),  
(20260315, NULL,     9,  13),  

(20260110, 20260120, 10, 4),   
(20260115, 20260125, 11, 7),   
(20260201, 20260210, 12, 8),   
(20260205, 20260215, 13, 12),  
(20260210, 20260220, 14, 14),  
(20260301, 20260310, 15, 15),  
(20260305, 20260318, 16, 16),  
(20260308, 20260320, 17, 17),  
(20260310, 20260322, 18, 18), 
(20260312, 20260325, 19, 19),  
(20260315, 20260326, 20, 20); 

UPDATE medico SET telefone = CASE CRM
    WHEN 1  THEN '(11)98765432'
    WHEN 2  THEN '(11)97654321'
    WHEN 3  THEN '(11)96543210'
    WHEN 4  THEN '(11)95432109'
    WHEN 5  THEN '(11)94321098'
    WHEN 6  THEN '(11)93210987'
    WHEN 7  THEN '(11)92109876'
    WHEN 8  THEN '(11)91098765'
    WHEN 9  THEN '(11)90987654'
    WHEN 10 THEN '(11)89876543'
END;

alter table leito
drop column data_entrada

ALTER TABLE leito ADD COLUMN data_entrada date;
ALTER TABLE leito ADD COLUMN data_saida text;

select * from leito

update leito set data_entrada='2026-03-01' where id_leito=10 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-05' where id_leito=6 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-07' where id_leito=5 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-09' where id_leito=2 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-11' where id_leito=13 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-21' where id_leito=11 and status_leito = 'ocupado';
update leito set data_entrada='2026-03-16' where id_leito=9 and status_leito = 'ocupado';


UPDATE leito SET data_saida = CASE id_leito

    WHEN 1  THEN NULL
    WHEN 2  THEN NULL
    WHEN 5  THEN NULL
    WHEN 6  THEN NULL
    WHEN 9  THEN NULL
    WHEN 10 THEN NULL
    WHEN 11 THEN NULL
    WHEN 13 THEN NULL
    ELSE NULL
END;

select * from atendimento

ALTER TABLE faturamento ADD CONSTRAINT id_atendimento
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento);

UPDATE faturamento SET
    tipo_faturamento  = CASE id_internacao
        WHEN 1  THEN 'internação'
        WHEN 2  THEN 'internação'
        WHEN 3  THEN 'internação'
        WHEN 4  THEN 'internação'
        WHEN 5  THEN 'internação'
        WHEN 6  THEN 'internação'
        WHEN 7  THEN 'internação'
        WHEN 8  THEN 'internação'
        WHEN 9  THEN 'internação'
        WHEN 10 THEN 'consulta'
        WHEN 11 THEN 'consulta'
        WHEN 12 THEN 'consulta'
        WHEN 13 THEN 'consulta'
        WHEN 14 THEN 'consulta'
        WHEN 15 THEN 'exame'
        WHEN 16 THEN 'exame'
        WHEN 17 THEN 'exame'
        WHEN 18 THEN 'exame'
        WHEN 19 THEN 'exame'
        WHEN 20 THEN 'exame'
    END::tipo_faturamento,
    preco_faturamento = CASE id_internacao

        WHEN 1  THEN 8500.00
        WHEN 2  THEN 4200.00
        WHEN 3  THEN 6300.00
        WHEN 4  THEN 3100.00
        WHEN 5  THEN 3800.00
        WHEN 6  THEN 5400.00
        WHEN 7  THEN 9200.00
        WHEN 8  THEN 4600.00
        WHEN 9  THEN 7100.00

        WHEN 10 THEN 350.00
        WHEN 11 THEN 280.00
        WHEN 12 THEN 420.00
        WHEN 13 THEN 500.00
        WHEN 14 THEN 310.00

        WHEN 15 THEN 180.00
        WHEN 16 THEN 350.00
        WHEN 17 THEN 480.00
        WHEN 18 THEN 90.00
        WHEN 19 THEN 260.00
        WHEN 20 THEN 120.00
    END,
    id_plano          = CASE id_internacao
        WHEN 1  THEN 1
        WHEN 2  THEN 1
        WHEN 3  THEN 2
        WHEN 4  THEN 2
        WHEN 5  THEN 3
        WHEN 6  THEN 3
        WHEN 7  THEN 4
        WHEN 8  THEN 4
        WHEN 9  THEN 5
        WHEN 10 THEN 5
        WHEN 11 THEN 1
        WHEN 12 THEN 2
        WHEN 13 THEN 3
        WHEN 14 THEN 4
        WHEN 15 THEN 5
        WHEN 16 THEN 1
        WHEN 17 THEN 2
        WHEN 18 THEN 3
        WHEN 19 THEN 4
        WHEN 20 THEN 5
    END,
    valor_total       = CASE id_internacao

        WHEN 1  THEN 9350.00
        WHEN 2  THEN 4620.00
        WHEN 3  THEN 6930.00
        WHEN 4  THEN 3410.00
        WHEN 5  THEN 4180.00
        WHEN 6  THEN 5940.00
        WHEN 7  THEN 10120.00
        WHEN 8  THEN 5060.00
        WHEN 9  THEN 7810.00

        WHEN 10 THEN 385.00
        WHEN 11 THEN 308.00
        WHEN 12 THEN 462.00
        WHEN 13 THEN 550.00
        WHEN 14 THEN 341.00

        WHEN 15 THEN 198.00
        WHEN 16 THEN 385.00
        WHEN 17 THEN 528.00
        WHEN 18 THEN 99.00
        WHEN 19 THEN 286.00
        WHEN 20 THEN 132.00
    END;

-- att fk atendimento > faturamento
alter table faturamento add column id_atendimento integer;
alter table faturamento add constraint fk_atendimento_faturado
	foreign key (id_atendimento) references atendimento (id_atendimento)
	
ALTER TABLE atendimento ADD COLUMN valor_previo numeric(10,2);


UPDATE atendimento SET valor_previo = CASE tipo_atendimento
    WHEN 'consulta'   THEN CASE CRM
        WHEN 1  THEN 350.00
        WHEN 2  THEN 320.00
        WHEN 3  THEN 280.00
        WHEN 4  THEN 300.00
        WHEN 5  THEN 400.00
        WHEN 6  THEN 450.00
        WHEN 7  THEN 350.00
        WHEN 8  THEN 380.00
        WHEN 9  THEN 290.00
        WHEN 10 THEN 420.00
    END
    WHEN 'emergência' THEN CASE CRM
        WHEN 1  THEN 850.00
        WHEN 2  THEN 900.00
        WHEN 4  THEN 780.00
        WHEN 7  THEN 920.00
        WHEN 9  THEN 800.00
        WHEN 10 THEN 860.00
    END
    WHEN 'revisão'    THEN CASE CRM
        WHEN 1  THEN 180.00
        WHEN 2  THEN 160.00
        WHEN 3  THEN 150.00
        WHEN 5  THEN 200.00
        WHEN 6  THEN 210.00
        WHEN 8  THEN 190.00
        WHEN 10 THEN 170.00
    END
END;

UPDATE faturamento SET id_atendimento = CASE id_internacao
    WHEN 10 THEN 1
    WHEN 11 THEN 2
    WHEN 12 THEN 3
    WHEN 13 THEN 4
    WHEN 14 THEN 5
    WHEN 15 THEN 6
    WHEN 16 THEN 7
    WHEN 17 THEN 8
    WHEN 18 THEN 9
    WHEN 19 THEN 10
    WHEN 20 THEN 11
END;

-- alterando enum de tipo de atendimento :
ALTER TYPE tipo_atendimento RENAME VALUE 'emergência' TO 'internação';
ALTER TYPE tipo_atendimento RENAME VALUE 'revisão' TO 'exame';

select * from atendimento

-- Consulta 1 quais são os nomes e telefones de todos os médicos da especialidade “Cardiologia”?
select nome, telefone, especialidade from medico where especialidade = 'Cardiologia' 


-- Consulta 2 Liste o nome e o CPF de todos os pacientes que possuem o plano de saúde “Unimed”.
select pa.nome, pa.cpf, ps.operadora from paciente pa
inner join plano_de_saude ps on ps.id_plano = pa.id_paciente
where ps.operadora = 'Unimed' group by (pa.nome, pa.cpf, ps.operadora)


-- Consulta 3 Quais exames ainda não têm resultado (data_resultado IS NULL) e foram solicitados no mês atual? Quantidade de exames por laboratório.

	create or replace view view_lab_exame_quantidade as
		select lab.nome, count(lab.id_laboratorio) from laboratorio lab
		inner join exame e
		on lab.id_laboratorio = e.id_laboratorio
		where data_solicitacao between date'2026-03-01' and date'2026-03-31'
		and data_resultado is null group by lab.id_laboratorio
	
	create or replace view view_lab_exame as
		select lab.nome, e.data_solicitacao, e.data_resultado from laboratorio lab
		inner join exame e
		on lab.id_laboratorio = e.id_laboratorio
		where data_solicitacao between date'2026-03-01' and date'2026-03-31'
		and data_resultado is null group by lab.nome, e.data_solicitacao, e.data_resultado

-- não foi possível fazer uma consulta dupla com UNION
 select * from view_lab_exame

 select * from view_lab_exame_quantidade

 
 -- Consulta 4 Liste o nome do paciente, o número do leito e a data de entrada para todas as internações ativas (data_saida IS NULL).
 select * from paciente
 select * from leito
 
select pa.nome, l.data_entrada, l.id_leito from paciente pa
inner join leito l on l.id_leito = pa.id_leito
where l.data_saida is null and not (l.data_entrada is null) group by (pa.nome, l.data_entrada, l.id_leito)
 

-- Consulta 5 Quantos atendimentos cada médico realizou no último mês? Apresente o nome do médico e a quantidade. 
-- Qual médico com maior número de atendimentos?

select * from medico
select * from atendimento

	create or replace view view_atendimento_medico as
		select m.nome, count(a.crm) as contagem from medico m
		inner join atendimento a
		on m.crm = a.crm
		where data between date'2026-02-01' and date'2026-02-28' and a.status_atendimento = 'realizado'
		group by m.crm

select nome, max(contagem) from view_atendimento_medico group by nome


-- Consulta 6 Qual a porcentagem de leitos ocupados em cada ala? Apresente o nome da ala e a porcentagem .
select * from leito
select * from ala

SELECT 
    a.nome,
    ROUND( ( COUNT(CASE WHEN l.status_leito = 'ocupado' THEN 1 END)::decimal / COUNT(*) ) * 100, 2 ) AS porcentagem_ocupada
FROM leito l
JOIN ala a ON l.id_ala = a.id_ala
GROUP BY a.nome;


-- Consulta 7 Qual o valor total faturado para cada plano de saúde no ano de 2026? Apresente o nome do plano e o valor total.
select * from plano_de_saude

select ps.nome, sum(f.valor_total) as valor_total from faturamento f
inner join plano_de_saude ps
on f.id_plano = ps.id_plano
where extract(year from f.data_entrada) = 2026
group by ps.nome

-- Consulta 8 Quais são os dois medicamentos mais prescritos no hospital? Apresente o nome do medicamento e a quantidade de prescrições.

select * from medicamento_prescricao
select * from medicamento

select m.nome, count(mp.id_medicamento) as mais_prescrito from medicamento m
inner join medicamento_prescricao mp 
on mp.id_medicamento = m.id_medicamento 
group by m.nome 
order by mais_prescrito desc limit 2


-- Consulta 9 Liste o nome do médico, a especialidade e a quantidade de pacientes atendidos por cada médico.

select me.nome, me.especialidade, count(at.id_atendimento) as qnt_atendimento from medico me
inner join atendimento at 
on me.crm = at.crm
group by me.nome , me.especialidade
order by qnt_atendimento desc


-- Consulta 10 Quais leitos estão ocupados há mais de 15 dias? Apresente o número do leito, o nome do paciente e a data de entrada.
select * from leito
select * from paciente


select l.status_leito = 'ocupado', l.id_leito, p.nome ,l.data_entrada from leito l
inner join paciente p
on l.id_leito = p.id_leito 
where l.data_entrada < current_date - interval '15 days' ;


-- Consulta 11 Qual o valor total faturado por tipo de atendimento (consulta, exame, internação)
select * from atendimento
select * from faturamento

select at.tipo_atendimento, sum(at.valor_previo) as valor_total from atendimento at
inner join faturamento fa 
on at.id_atendimento = fa.id_atendimento  
group by at.tipo_atendimento

-- Consulta 12 Qual o valor total faturado por um determinado plano de saúde.
select * from faturamento
select * from plano_de_saude 

select ps.operadora, sum(fa.valor_total) as valor_total from plano_de_saude ps
inner join faturamento fa 
on ps.id_plano = fa.id_plano  
group by ps.operadora
-- fim 