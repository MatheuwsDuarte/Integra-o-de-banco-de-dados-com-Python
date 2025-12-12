USE energia;

select * from tb_uf;
select * from tb_cliente;
select * from tb_gerador;
select * from tb_registro_geracao;

-- Qual foi o cliente que gerou a maior quantidade de energia entre os dias 01 e 10 de janeiro de 2024?
SELECT 
    c.nome_cliente, SUM(rg.geracao_energia_kWh) AS total_gerado -- nome do cliente e soma de toda energia gerada
FROM
    tb_registro_geracao rg
        JOIN -- usar o join para ligar as tabelas
    tb_gerador g ON rg.id_gerador = g.id_gerador
        JOIN
    tb_cliente c ON g.id_cliente = c.id_cliente
WHERE
    rg.data_registro BETWEEN '2024-01-01' AND '2024-01-10'
GROUP BY c.nome_cliente -- agrupar os resultados para cada cliente
ORDER BY total_gerado DESC -- ordenar lista do maior para o menor (DESC)
LIMIT 1; -- pegar apenas o primeiro da lista

-- Qual gerador do cliente "Libero Corp." que mais contribuiu para a geração de energia em janeiro?
SELECT 
	g.nome_gerador, SUM(rg.geracao_energia_kWh) AS total_gerado -- nome do gerador e somar a energia produzida para comparar depois
FROM
	tb_gerador g
JOIN
	tb_cliente c ON g.id_cliente = c.id_cliente
JOIN
	tb_registro_geracao rg ON g.id_gerador = rg.id_gerador
WHERE 
	c.nome_cliente = 'Libero Corp.' -- apenas os geradores da LiberoCorp
    AND rg.data_registro BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY
	g.nome_gerador
ORDER BY 
	total_gerado DESC
LIMIT 1;

-- Há algum gerador que não gerou energia em janeiro de 2024?
SELECT
	g.nome_gerador, c.nome_cliente
FROM
	tb_gerador g -- tabela principal e o lado esquerdo do left join
JOIN
	tb_cliente c ON g.id_cliente = c.id_cliente
LEFT JOIN -- consultar todos os geradores, se nao tiver registro preencher com null
	tb_registro_geracao rg
	ON g.id_gerador = rg.id_gerador 
    AND rg.data_registro BETWEEN '2024-01-01' AND '2024-01-31' -- tenta encontrar os registros de janeiro e se nao achar deixar null
WHERE
	rg.id_registro IS NULL; -- mostrar onde nao encontrou registro de geração


-- Qual é a geração média diária para cada gerador de clientes que estão no estado do Paraná (PR)?
SELECT 
	g.nome_gerador, c.nome_cliente, ROUND(AVG(rg.geracao_energia_kWh), 2) AS media_diaria_kwh -- usei AVG para calcular a média dos registros do gerador, usei o ROUND para arredondar em 2 casas decimais
FROM
	tb_registro_geracao rg
JOIN
	tb_gerador g ON rg.id_gerador = g.id_gerador
JOIN
	tb_cliente c ON g.id_cliente = c.id_cliente
JOIN
	tb_uf u ON c.id_uf = u.id_uf
WHERE
	u.uf = 'PR' -- filtrando pela sigla
GROUP BY
	g.nome_gerador, c.nome_cliente;

-- Considerando a geração total de energia para todos os clientes, qual foi o dia de pico de geração? 
SELECT
	data_registro, SUM(geracao_energia_kWh) AS total_gerado_no_dia -- somar tudo as linhas das datas 
FROM
	tb_registro_geracao
GROUP BY
	data_registro -- cria uma linha para cada dia diferente encontrado
ORDER BY
	total_gerado_no_dia DESC
LIMIT 1;

-- Tabela: tb_uf
CREATE TABLE tb_uf (
    id_uf INT NOT NULL,
    uf VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_uf)
);

-- Tabela: tb_cliente
CREATE TABLE tb_cliente (
    id_cliente int NOT NULL,
    nome_cliente varchar(50) NOT NULL,
    id_uf int NOT NULL,
    CONSTRAINT tb_cliente_pk PRIMARY KEY (id_cliente),
    CONSTRAINT tb_cliente_tb_uf FOREIGN KEY (id_uf) REFERENCES tb_uf (id_uf)
);

-- Tabela: tb_gerador
CREATE TABLE tb_gerador (
    id_gerador int NOT NULL,
    nome_gerador varchar(50) NOT NULL,
    id_cliente int NOT NULL,
    CONSTRAINT tb_gerador_pk PRIMARY KEY (id_gerador),
    CONSTRAINT tb_gerador_tb_cliente FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id_cliente)
);

-- Tabela: tb_registro_geracao
CREATE TABLE tb_registro_geracao (
    id_registro int NOT NULL,
    id_gerador int NOT NULL,
    data_registro date NOT NULL,
    geracao_energia_kWh decimal(10,2) NOT NULL,
    CONSTRAINT tb_registro_geracao_pk PRIMARY KEY (id_registro),
    CONSTRAINT tb_registro_geracao_tb_gerador FOREIGN KEY (id_gerador) REFERENCES tb_gerador (id_gerador)
);

USE energia;

-- Dados para tb_uf
INSERT INTO energia.tb_uf (id_uf, uf)
VALUES
  (1, 'PR'),
  (2, 'SP'),
  (3, 'RS'),
  (4, 'SC'),
  (5, 'PA'),
  (6, 'PE'),
  (7, 'AM'),
  (8, 'TO'),
  (9, 'PI'),
  (10, 'AC');

-- Dados para tb_cliente
INSERT INTO energia.tb_cliente (id_cliente, nome_cliente, id_uf)
VALUES
  (1, 'Libero Corp.', 2),
  (2, 'Aliquam Associates', 6),
  (3, 'Pellentesque Industries', 1),
  (4, 'Cubilia Inc.', 9),
  (5, 'Ipsum Industries', 2),
  (6, 'Sit LLC', 10),
  (7, 'Pharetra LLC', 4),
  (8, 'Imperdiet Limited', 6);

-- Dados para tb_gerador
INSERT INTO energia.tb_gerador (id_gerador, nome_gerador, id_cliente)
VALUES
  (1, 'Gerador A', 4),
  (2, 'Gerador B', 2),
  (3, 'Gerador C', 1),
  (4, 'Gerador D', 3),
  (5, 'Gerador E', 5),
  (6, 'Gerador F', 6),
  (7, 'Gerador G', 7),
  (8, 'Gerador H', 8),
  (9, 'Gerador I', 1);

-- Dados para tb_registro_geracao
INSERT INTO energia.tb_registro_geracao (id_registro, id_gerador, data_registro, geracao_energia_kwh)
VALUES
  (1, 1, '2024-01-01', 5000),
  (2, 2, '2024-01-01', 7000),
  (3, 3, '2024-01-01', 9000),
  (4, 4, '2024-01-01', 6000),
  (5, 5, '2024-01-01', 8000),
  (6, 6, '2024-01-01', 4000),
  (7, 7, '2024-01-01', 5500),
  (8, 8, '2024-01-01', 7500),
  (9, 1, '2024-01-02', 5100),
  (10, 2, '2024-01-02', 7200),
  (11, 3, '2024-01-02', 9100),
  (12, 4, '2024-01-02', 6100),
  (13, 5, '2024-01-02', 8100),
  (14, 6, '2024-01-02', 4200),
  (15, 7, '2024-01-02', 5600),
  (16, 8, '2024-01-02', 7600),
  (17, 1, '2024-01-03', 5200),
  (18, 2, '2024-01-03', 7300),
  (19, 3, '2024-01-03', 9200),
  (20, 4, '2024-01-03', 6200),
  (21, 5, '2024-01-03', 8200),
  (22, 6, '2024-01-03', 4300),
  (23, 7, '2024-01-03', 5700),
  (24, 8, '2024-01-03', 7700),
  (25, 1, '2024-01-04', 5300),
  (26, 2, '2024-01-04', 7400),
  (27, 3, '2024-01-04', 9300),
  (28, 4, '2024-01-04', 6300),
  (29, 5, '2024-01-04', 8300),
  (30, 6, '2024-01-04', 4400),
  (31, 7, '2024-01-04', 5800),
  (32, 8, '2024-01-04', 7800),
  (33, 1, '2024-01-05', 5400),
  (34, 2, '2024-01-05', 7500),
  (35, 3, '2024-01-05', 9400),
  (36, 4, '2024-01-05', 6400),
  (37, 5, '2024-01-05', 8400),
  (38, 6, '2024-01-05', 4500),
  (39, 7, '2024-01-05', 5900),
  (40, 8, '2024-01-05', 7900),
  (41, 1, '2024-01-06', 5500),
  (42, 2, '2024-01-06', 7600),
  (43, 3, '2024-01-06', 9500),
  (44, 4, '2024-01-06', 6500),
  (45, 5, '2024-01-06', 8500),
  (46, 6, '2024-01-06', 4600),
  (47, 7, '2024-01-06', 6000),
  (48, 8, '2024-01-06', 8000),
  (49, 1, '2024-01-07', 5600),
  (50, 2, '2024-01-07', 7700),
  (51, 3, '2024-01-07', 9600),
  (52, 4, '2024-01-07', 6600),
  (53, 5, '2024-01-07', 8600),
  (54, 6, '2024-01-07', 4700),
  (55, 7, '2024-01-07', 6100),
  (56, 8, '2024-01-07', 8100),
  (57, 1, '2024-01-08', 5700),
  (58, 2, '2024-01-08', 7800),
  (59, 3, '2024-01-08', 9700),
  (60, 4, '2024-01-08', 6700),
  (61, 5, '2024-01-08', 8700),
  (62, 6, '2024-01-08', 4800),
  (63, 7, '2024-01-08', 6200),
  (64, 8, '2024-01-08', 8200),
  (65, 1, '2024-01-09', 5800),
  (66, 2, '2024-01-09', 7900),
  (67, 3, '2024-01-09', 9800),
  (68, 4, '2024-01-09', 6800),
  (69, 5, '2024-01-09', 8800),
  (70, 6, '2024-01-09', 4900),
  (71, 7, '2024-01-09', 6300),
  (72, 8, '2024-01-09', 8300),
  (73, 1, '2024-01-10', 5900),
  (74, 2, '2024-01-10', 8000),
  (75, 3, '2024-01-10', 9900),
  (76, 4, '2024-01-10', 6900),
  (77, 5, '2024-01-10', 8900),
  (78, 6, '2024-01-10', 5000),
  (79, 7, '2024-01-10', 6400),
  (80, 8, '2024-01-10', 8400),
  (81, 1, '2024-01-11', 6000),
  (82, 2, '2024-01-11', 8100),
  (83, 3, '2024-01-11', 10000),
  (84, 4, '2024-01-11', 7000),
  (85, 5, '2024-01-11', 9000),
  (86, 6, '2024-01-11', 5100),
  (87, 7, '2024-01-11', 6500),
  (88, 8, '2024-01-11', 8500),
  (89, 1, '2024-01-12', 6100),
  (90, 2, '2024-01-12', 8200),
  (91, 3, '2024-01-12', 10100),
  (92, 4, '2024-01-12', 7100),
  (93, 5, '2024-01-12', 9100),
  (94, 6, '2024-01-12', 5200),
  (95, 7, '2024-01-12', 6600),
  (96, 8, '2024-01-12', 8600),
  (97, 1, '2024-01-13', 6200),
  (98, 2, '2024-01-13', 8300),
  (99, 3, '2024-01-13', 10200),
  (100, 4, '2024-01-13', 7200),
  (101, 5, '2024-01-13', 9200),
  (102, 6, '2024-01-13', 5300),
  (103, 7, '2024-01-13', 6700),
  (104, 8, '2024-01-13', 8700),
  (105, 1, '2024-01-14', 6300),
  (106, 2, '2024-01-14', 8400),
  (107, 3, '2024-01-14', 10300),
  (108, 4, '2024-01-14', 7300),
  (109, 5, '2024-01-14', 9300),
  (110, 6, '2024-01-14', 5400),
  (111, 7, '2024-01-14', 6800),
  (112, 8, '2024-01-14', 8800),
  (113, 1, '2024-01-15', 6400),
  (114, 2, '2024-01-15', 8500),
  (115, 3, '2024-01-15', 10400),
  (116, 4, '2024-01-15', 7400),
  (117, 5, '2024-01-15', 9400),
  (118, 6, '2024-01-15', 5500),
  (119, 7, '2024-01-15', 6900),
  (120, 8, '2024-01-15', 8900),
  (121, 1, '2024-01-16', 6500),
  (122, 2, '2024-01-16', 8600),
  (123, 3, '2024-01-16', 10500),
  (124, 4, '2024-01-16', 7500),
  (125, 5, '2024-01-16', 9500),
  (126, 6, '2024-01-16', 5600),
  (127, 7, '2024-01-16', 7000),
  (128, 8, '2024-01-16', 9000),
  (129, 1, '2024-01-17', 10600),
  (130, 2, '2024-01-17', 8800),
  (131, 3, '2024-01-17', 10700),
  (132, 4, '2024-01-17', 7600),
  (133, 5, '2024-01-17', 9600),
  (134, 6, '2024-01-17', 5700),
  (135, 7, '2024-01-17', 7100),
  (136, 8, '2024-01-17', 9100),
  (137, 1, '2024-01-18', 6700),
  (138, 2, '2024-01-18', 8900),
  (139, 3, '2024-01-18', 10800),
  (140, 4, '2024-01-18', 7700),
  (141, 5, '2024-01-18', 9700),
  (142, 6, '2024-01-18', 5800),
  (143, 7, '2024-01-18', 7200),
  (144, 8, '2024-01-18', 9200),
  (145, 1, '2024-01-19', 6800),
  (146, 2, '2024-01-19', 9000),
  (147, 3, '2024-01-19', 10900),
  (148, 4, '2024-01-19', 7800),
  (149, 5, '2024-01-19', 9800),
  (150, 6, '2024-01-19', 5900),
  (151, 7, '2024-01-19', 7300),
  (152, 8, '2024-01-19', 9300),
  (153, 1, '2024-01-20', 6900),
  (154, 2, '2024-01-20', 9100),
  (155, 3, '2024-01-20', 11000),
  (156, 4, '2024-01-20', 7900),
  (157, 5, '2024-01-20', 9900),
  (158, 6, '2024-01-20', 6000),
  (159, 7, '2024-01-20', 7400),
  (160, 8, '2024-01-20', 9400),
  (161, 1, '2024-01-21', 7000),
  (162, 2, '2024-01-21', 9200),
  (163, 3, '2024-01-21', 11100),
  (164, 4, '2024-01-21', 8000),
  (165, 5, '2024-01-21', 10000),
  (166, 6, '2024-01-21', 6100),
  (167, 7, '2024-01-21', 7500),
  (168, 8, '2024-01-21', 9500),
  (169, 1, '2024-01-22', 7100),
  (170, 2, '2024-01-22', 9300),
  (171, 3, '2024-01-22', 11200),
  (172, 4, '2024-01-22', 8100),
  (173, 5, '2024-01-22', 10100),
  (174, 6, '2024-01-22', 6200),
  (175, 7, '2024-01-22', 7600),
  (176, 8, '2024-01-22', 9600),
  (177, 1, '2024-01-23', 7200),
  (178, 2, '2024-01-23', 9400),
  (179, 3, '2024-01-23', 11300),
  (180, 4, '2024-01-23', 8200),
  (181, 5, '2024-01-23', 10200),
  (182, 6, '2024-01-23', 6300),
  (183, 7, '2024-01-23', 7700),
  (184, 8, '2024-01-23', 9700),
  (185, 1, '2024-01-24', 11500),
  (186, 2, '2024-01-24', 9600),
  (187, 3, '2024-01-24', 11600),
  (188, 4, '2024-01-24', 8400),
  (189, 5, '2024-01-24', 10400),
  (190, 6, '2024-01-24', 6400),
  (191, 7, '2024-01-24', 7800),
  (192, 8, '2024-01-24', 9800),
  (193, 1, '2024-01-25', 7400),
  (194, 2, '2024-01-25', 9700),
  (195, 3, '2024-01-25', 11700),
  (196, 4, '2024-01-25', 8500),
  (197, 5, '2024-01-25', 10500),
  (198, 6, '2024-01-25', 6500),
  (199, 7, '2024-01-25', 7900),
  (200, 8, '2024-01-25', 9900),
  (201, 1, '2024-01-26', 7500),
  (202, 2, '2024-01-26', 9800),
  (203, 3, '2024-01-26', 11800),
  (204, 4, '2024-01-26', 8600),
  (205, 5, '2024-01-26', 10600),
  (206, 6, '2024-01-26', 6600),
  (207, 7, '2024-01-26', 8000),
  (208, 8, '2024-01-26', 10000),
  (209, 1, '2024-01-27', 7600),
  (210, 2, '2024-01-27', 9900),
  (211, 3, '2024-01-27', 11900),
  (212, 4, '2024-01-27', 8700),
  (213, 5, '2024-01-27', 10700),
  (214, 6, '2024-01-27', 6700),
  (215, 7, '2024-01-27', 8100),
  (216, 8, '2024-01-27', 10100),
  (217, 1, '2024-01-28', 7700),
  (218, 2, '2024-01-28', 10000),
  (219, 3, '2024-01-28', 12000),
  (220, 4, '2024-01-28', 8800),
  (221, 5, '2024-01-28', 10800),
  (222, 6, '2024-01-28', 6800),
  (223, 7, '2024-01-28', 8200),
  (224, 8, '2024-01-28', 10200),
  (225, 1, '2024-01-29', 7800),
  (226, 2, '2024-01-29', 10100),
  (227, 3, '2024-01-29', 12100),
  (228, 4, '2024-01-29', 8900),
  (229, 5, '2024-01-29', 10900),
  (230, 6, '2024-01-29', 6900),
  (231, 7, '2024-01-29', 8300),
  (232, 8, '2024-01-29', 10300),
  (233, 1, '2024-01-30', 7900),
  (234, 2, '2024-01-30', 10200),
  (235, 3, '2024-01-30', 12200),
  (236, 4, '2024-01-30', 9000),
  (237, 5, '2024-01-30', 11000),
  (238, 6, '2024-01-30', 7000);

