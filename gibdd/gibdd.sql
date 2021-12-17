--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_av(character, date, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_av(av character, d date, vin character) RETURNS void
    LANGUAGE sql
    AS $$
	INSERT INTO avarii(avariya,data_avarii,id_auto_av) VALUES (av, d, (SELECT id from list_auto() where vin_nomer=vin));
$$;


ALTER FUNCTION public.add_av(av character, d date, vin character) OWNER TO postgres;

--
-- Name: add_owner(character, date, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_owner(f character, data_p date, auto_vin character) RETURNS void
    LANGUAGE sql
    AS $$

INSERT INTO reestr_vladelcev(fio, data_postanovki, id_auto_rv) VALUES (f, data_p, (select id from auto where vin_nomer = auto_vin))

$$;


ALTER FUNCTION public.add_owner(f character, data_p date, auto_vin character) OWNER TO postgres;

--
-- Name: addmm(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addmm(ma character, mo character) RETURNS void
    LANGUAGE sql
    AS $$
	insert into model_marka (marka,model) values (ma, mo)
$$;


ALTER FUNCTION public.addmm(ma character, mo character) OWNER TO postgres;

--
-- Name: adduser(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.adduser(login character, pass character) RETURNS void
    LANGUAGE sql
    AS $$
	insert into accounts (login,pass) values (login,pass)
$$;


ALTER FUNCTION public.adduser(login character, pass character) OWNER TO postgres;

--
-- Name: addvin(character, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addvin(vin character, idmm integer) RETURNS void
    LANGUAGE sql
    AS $$
	INSERT INTO auto(vin_nomer, id_mm) VALUES (vin, idmm)
$$;


ALTER FUNCTION public.addvin(vin character, idmm integer) OWNER TO postgres;

--
-- Name: del_vin(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.del_vin(idvin integer) RETURNS void
    LANGUAGE sql
    AS $$
	DELETE FROM avarii WHERE  id_auto_av = idvin;
	DELETE FROM reestr_nomerov WHERE  id_auto_rn = idvin;
	DELETE FROM reestr_vladelcev WHERE  id_auto_rv = idvin;
	DELETE FROM auto WHERE  id = idvin;
$$;


ALTER FUNCTION public.del_vin(idvin integer) OWNER TO postgres;

--
-- Name: get_num(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_num() RETURNS TABLE(id integer, num character)
    LANGUAGE sql
    AS $$

SELECT id,number from reestr_nomerov;

$$;


ALTER FUNCTION public.get_num() OWNER TO postgres;

--
-- Name: get_owner(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_owner() RETURNS TABLE(id integer, fio character, data_postanovki date, data_snyatiya date, id_auto_rv integer)
    LANGUAGE sql
    AS $$

SELECT * from reestr_vladelcev;

$$;


ALTER FUNCTION public.get_owner() OWNER TO postgres;

--
-- Name: list_auto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.list_auto() RETURNS TABLE(id integer, vin_nomer character, id_mm integer, marka character, model character, num character, dtv date, dts date, fio character, dtp date, dtvs date, avariya character, dtavar date)
    LANGUAGE sql
    AS $$

select v.id, v.vin_nomer, v.id_mm, m.marka, m.model, n.number, n.data_vidachi, n.data_snyatiya, vl.fio, vl.data_postanovki,
		vl.data_snyatiya, a.avariya, a.data_avarii
from auto v inner join model_marka m on v.id_mm=m.id 
left join avarii a on a.id_auto_av=v.id
left join reestr_nomerov n on n.id_auto_rn=v.id
left join reestr_vladelcev vl on vl.id_auto_rv=v.id;

$$;


ALTER FUNCTION public.list_auto() OWNER TO postgres;

--
-- Name: set_login(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_login(log character) RETURNS TABLE(id integer, login character)
    LANGUAGE sql
    AS $$

select id, login
from accounts
where login= log;

$$;


ALTER FUNCTION public.set_login(log character) OWNER TO postgres;

--
-- Name: snyatie_gos_nomer(character, date, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.snyatie_gos_nomer(num character, dts date, vin character) RETURNS void
    LANGUAGE sql
    AS $$
UPDATE reestr_nomerov SET data_snyatiya=dts WHERE number = num and id_auto_rn = 
(select id from list_auto() where vin_nomer=vin
group by vin_nomer, id);
$$;


ALTER FUNCTION public.snyatie_gos_nomer(num character, dts date, vin character) OWNER TO postgres;

--
-- Name: update_owner(character, date, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_owner(f character, data_s date, auto_vin character) RETURNS void
    LANGUAGE sql
    AS $$

UPDATE reestr_vladelcev SET data_snyatiya=data_s WHERE (fio=f and id_auto_rv = (select id from auto where vin_nomer=auto_vin))

$$;


ALTER FUNCTION public.update_owner(f character, data_s date, auto_vin character) OWNER TO postgres;

--
-- Name: vidacha_gos_nomer(character, date, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vidacha_gos_nomer(num character, dtv date, vin character) RETURNS void
    LANGUAGE sql
    AS $$
insert into reestr_nomerov (number, data_vidachi,id_auto_rn) values (num, dtv, 
(select id from list_auto() where vin_nomer=vin
group by vin_nomer, id));
$$;


ALTER FUNCTION public.vidacha_gos_nomer(num character, dtv date, vin character) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auto (
    id integer NOT NULL,
    vin_nomer character(20),
    id_mm integer
);


ALTER TABLE public.auto OWNER TO postgres;

--
-- Name: Auto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Auto_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Auto_id_seq" OWNER TO postgres;

--
-- Name: Auto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Auto_id_seq" OWNED BY public.auto.id;


--
-- Name: avarii; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avarii (
    id integer NOT NULL,
    avariya character(1000),
    data_avarii date,
    id_auto_av integer
);


ALTER TABLE public.avarii OWNER TO postgres;

--
-- Name: Avarii_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Avarii_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Avarii_id_seq" OWNER TO postgres;

--
-- Name: Avarii_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Avarii_id_seq" OWNED BY public.avarii.id;


--
-- Name: model_marka; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_marka (
    id integer NOT NULL,
    marka character(40),
    model character(40)
);


ALTER TABLE public.model_marka OWNER TO postgres;

--
-- Name: Model_Marka_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Model_Marka_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Model_Marka_id_seq" OWNER TO postgres;

--
-- Name: Model_Marka_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Model_Marka_id_seq" OWNED BY public.model_marka.id;


--
-- Name: reestr_vladelcev; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reestr_vladelcev (
    id integer NOT NULL,
    fio character(50),
    data_postanovki date,
    data_snyatiya date,
    id_auto_rv integer
);


ALTER TABLE public.reestr_vladelcev OWNER TO postgres;

--
-- Name: Reestr_Vladelcev_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Reestr_Vladelcev_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Reestr_Vladelcev_id_seq" OWNER TO postgres;

--
-- Name: Reestr_Vladelcev_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Reestr_Vladelcev_id_seq" OWNED BY public.reestr_vladelcev.id;


--
-- Name: reestr_nomerov; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reestr_nomerov (
    id integer NOT NULL,
    number character(10),
    data_vidachi date,
    data_snyatiya date,
    id_auto_rn integer
);


ALTER TABLE public.reestr_nomerov OWNER TO postgres;

--
-- Name: Reestr_nomerov_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Reestr_nomerov_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Reestr_nomerov_id_seq" OWNER TO postgres;

--
-- Name: Reestr_nomerov_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Reestr_nomerov_id_seq" OWNED BY public.reestr_nomerov.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    login character(30),
    pass character(32)
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: auto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto ALTER COLUMN id SET DEFAULT nextval('public."Auto_id_seq"'::regclass);


--
-- Name: avarii id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avarii ALTER COLUMN id SET DEFAULT nextval('public."Avarii_id_seq"'::regclass);


--
-- Name: model_marka id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_marka ALTER COLUMN id SET DEFAULT nextval('public."Model_Marka_id_seq"'::regclass);


--
-- Name: reestr_nomerov id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_nomerov ALTER COLUMN id SET DEFAULT nextval('public."Reestr_nomerov_id_seq"'::regclass);


--
-- Name: reestr_vladelcev id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_vladelcev ALTER COLUMN id SET DEFAULT nextval('public."Reestr_Vladelcev_id_seq"'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id, login, pass) FROM stdin;
1	admin                         	123456                          
18	admin3                        	333                             
19	admin4                        	4444                            
20	admin5                        	55555                           
21	admin6                        	666666                          
\.


--
-- Data for Name: auto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auto (id, vin_nomer, id_mm) FROM stdin;
21	AAAAAAAAAAA         	12
\.


--
-- Data for Name: avarii; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avarii (id, avariya, data_avarii, id_auto_av) FROM stdin;
11	rararafdfsgernterngrebtserhnseryresnghfbdrt64565s4ybs5vys35ycs5ynsb6587bs4v3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	2021-12-17	21
\.


--
-- Data for Name: model_marka; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_marka (id, marka, model) FROM stdin;
1140	VAZ                                     	Niva Urban                              
1141	VAZ                                     	Kalina Sport                            
1	Acura                                   	CL                                      
2	Acura                                   	EL                                      
3	Acura                                   	ILX                                     
4	Acura                                   	Integra                                 
5	Acura                                   	MDX                                     
6	Acura                                   	NSX                                     
7	Acura                                   	RDX                                     
8	Acura                                   	RL                                      
9	Acura                                   	RLX                                     
10	Acura                                   	RSX                                     
11	Acura                                   	TL                                      
12	Acura                                   	TLX                                     
13	Acura                                   	TSX                                     
14	Acura                                   	ZDX                                     
15	Alfa Romeo                              	146                                     
16	Alfa Romeo                              	147                                     
17	Alfa Romeo                              	147 GTA                                 
18	Alfa Romeo                              	156                                     
19	Alfa Romeo                              	156 GTA                                 
20	Alfa Romeo                              	159                                     
21	Alfa Romeo                              	166                                     
22	Alfa Romeo                              	4C                                      
23	Alfa Romeo                              	8C Competizione                         
24	Alfa Romeo                              	Brera                                   
25	Alfa Romeo                              	Giulia                                  
26	Alfa Romeo                              	Giulietta                               
27	Alfa Romeo                              	GT                                      
28	Alfa Romeo                              	GTV                                     
29	Alfa Romeo                              	MiTo                                    
30	Alfa Romeo                              	Spider                                  
31	Alfa Romeo                              	Stelvio                                 
32	Aston Martin                            	Cygnet                                  
33	Aston Martin                            	DB11                                    
34	Aston Martin                            	DB9                                     
35	Aston Martin                            	DBS                                     
36	Aston Martin                            	DBS Violante                            
37	Aston Martin                            	DBX                                     
38	Aston Martin                            	Rapide                                  
39	Aston Martin                            	V12 Vantage                             
40	Aston Martin                            	V8 Vantage                              
41	Aston Martin                            	Valkyrie                                
42	Aston Martin                            	Vanquish                                
43	Aston Martin                            	Virage                                  
44	Aston Martin                            	Zagato Coupe                            
45	Audi                                    	A1                                      
46	Audi                                    	A2                                      
47	Audi                                    	A3                                      
48	Audi                                    	A4                                      
49	Audi                                    	A4 Allroad Quattro                      
50	Audi                                    	A5                                      
51	Audi                                    	A6                                      
52	Audi                                    	A7                                      
53	Audi                                    	A8                                      
54	Audi                                    	Allroad                                 
55	Audi                                    	E-Tron                                  
56	Audi                                    	Q2                                      
57	Audi                                    	Q3                                      
58	Audi                                    	Q5                                      
59	Audi                                    	Q7                                      
60	Audi                                    	Q8                                      
61	Audi                                    	R8                                      
62	Audi                                    	RS Q3                                   
63	Audi                                    	RS3                                     
64	Audi                                    	RS4                                     
65	Audi                                    	RS5                                     
66	Audi                                    	RS6                                     
67	Audi                                    	RS7                                     
68	Audi                                    	S3                                      
69	Audi                                    	S4                                      
70	Audi                                    	S5                                      
71	Audi                                    	S6                                      
72	Audi                                    	S7                                      
73	Audi                                    	S8                                      
74	Audi                                    	SQ2                                     
75	Audi                                    	SQ5                                     
76	Audi                                    	SQ7                                     
77	Audi                                    	SQ8                                     
78	Audi                                    	TT                                      
79	Audi                                    	TT RS                                   
80	Audi                                    	TTS                                     
81	Bentley                                 	Arnage                                  
82	Bentley                                 	Azure                                   
83	Bentley                                 	Bentayga                                
84	Bentley                                 	Brooklands                              
85	Bentley                                 	Continental                             
86	Bentley                                 	Continental Flying Spur                 
87	Bentley                                 	Continental GT                          
88	Bentley                                 	Flying Spur                             
89	Bentley                                 	Mulsanne                                
90	BMW                                     	1 series                                
91	BMW                                     	2 series                                
92	BMW                                     	3 series                                
93	BMW                                     	4 series                                
94	BMW                                     	5 series                                
95	BMW                                     	6 series                                
96	BMW                                     	7 series                                
97	BMW                                     	8 series                                
98	BMW                                     	i3                                      
99	BMW                                     	i8                                      
100	BMW                                     	M2                                      
101	BMW                                     	M3                                      
102	BMW                                     	M4                                      
103	BMW                                     	M5                                      
104	BMW                                     	M6                                      
105	BMW                                     	X1                                      
106	BMW                                     	X2                                      
107	BMW                                     	X3                                      
108	BMW                                     	X3 M                                    
109	BMW                                     	X4                                      
110	BMW                                     	X4 M                                    
111	BMW                                     	X5                                      
112	BMW                                     	X5 M                                    
113	BMW                                     	X6                                      
114	BMW                                     	X6 M                                    
115	BMW                                     	X7                                      
116	BMW                                     	Z3                                      
117	BMW                                     	Z4                                      
118	BMW                                     	Z8                                      
119	Brilliance                              	H230                                    
120	Brilliance                              	V3                                      
121	Brilliance                              	V5                                      
122	Bugatti                                 	Veyron                                  
123	Buick                                   	Century                                 
124	Buick                                   	Enclave                                 
125	Buick                                   	Envision                                
126	Buick                                   	La Crosse                               
127	Buick                                   	Le Sabre                                
128	Buick                                   	Lucerne                                 
129	Buick                                   	Park Avenue                             
130	Buick                                   	Rainier                                 
131	Buick                                   	Regal                                   
132	Buick                                   	Rendezvouz                              
133	Buick                                   	Terraza                                 
134	Buick                                   	Verano                                  
135	BYD                                     	Qin                                     
136	Cadillac                                	ATS                                     
137	Cadillac                                	ATS-V                                   
138	Cadillac                                	BLS                                     
139	Cadillac                                	CT6                                     
140	Cadillac                                	CTS                                     
141	Cadillac                                	De Ville                                
142	Cadillac                                	DTS                                     
143	Cadillac                                	Eldorado                                
144	Cadillac                                	ELR                                     
145	Cadillac                                	Escalade                                
146	Cadillac                                	Seville                                 
147	Cadillac                                	SRX                                     
148	Cadillac                                	STS                                     
149	Cadillac                                	XLR                                     
150	Cadillac                                	XT4                                     
151	Cadillac                                	XT5                                     
152	Cadillac                                	XT6                                     
153	Cadillac                                	XTS                                     
154	Changan                                 	CS35                                    
155	Changan                                 	CS35 Plus                               
156	Changan                                 	CS55                                    
157	Changan                                 	CS75                                    
158	Changan                                 	CS95                                    
159	Changan                                 	Eado                                    
160	Changan                                 	Raeton                                  
161	Chery                                   	Amulet                                  
162	Chery                                   	Arrizo 7                                
163	Chery                                   	Bonus                                   
164	Chery                                   	Bonus 3                                 
165	Chery                                   	CrossEastar                             
166	Chery                                   	Eastar                                  
167	Chery                                   	Fora                                    
168	Chery                                   	IndiS                                   
169	Chery                                   	Kimo                                    
170	Chery                                   	M11                                     
171	Chery                                   	QQ                                      
172	Chery                                   	QQ6                                     
173	Chery                                   	Tiggo                                   
174	Chery                                   	Tiggo 3                                 
175	Chery                                   	Tiggo 4                                 
176	Chery                                   	Tiggo 5                                 
177	Chery                                   	Tiggo 7                                 
178	Chery                                   	Tiggo 8                                 
179	Chery                                   	Very                                    
180	Chevrolet                               	Astro                                   
181	Chevrolet                               	Avalanche                               
182	Chevrolet                               	Aveo                                    
183	Chevrolet                               	Blazer                                  
184	Chevrolet                               	Camaro                                  
185	Chevrolet                               	Captiva                                 
186	Chevrolet                               	Cavalier                                
187	Chevrolet                               	Cobalt                                  
188	Chevrolet                               	Colorado                                
189	Chevrolet                               	Corvette                                
190	Chevrolet                               	Cruze                                   
191	Chevrolet                               	Epica                                   
192	Chevrolet                               	Equinox                                 
193	Chevrolet                               	Express                                 
194	Chevrolet                               	HHR                                     
195	Chevrolet                               	Impala                                  
196	Chevrolet                               	Lacetti                                 
197	Chevrolet                               	Lanos                                   
198	Chevrolet                               	Malibu                                  
199	Chevrolet                               	Monte Carlo                             
200	Chevrolet                               	Niva                                    
201	Chevrolet                               	Orlando                                 
202	Chevrolet                               	Rezzo                                   
203	Chevrolet                               	Silverado                               
204	Chevrolet                               	Silverado 2500 HD                       
205	Chevrolet                               	Spark                                   
206	Chevrolet                               	SSR                                     
207	Chevrolet                               	Suburban                                
208	Chevrolet                               	Tahoe                                   
209	Chevrolet                               	TrailBlazer                             
210	Chevrolet                               	Traverse                                
211	Chevrolet                               	Trax                                    
212	Chevrolet                               	Uplander                                
213	Chevrolet                               	Venture                                 
214	Chrysler                                	200                                     
215	Chrysler                                	300                                     
216	Chrysler                                	300M                                    
217	Chrysler                                	Aspen                                   
218	Chrysler                                	Concorde                                
219	Chrysler                                	Crossfire                               
220	Chrysler                                	Grand Voyager                           
221	Chrysler                                	Pacifica                                
222	Chrysler                                	PT Cruiser                              
223	Chrysler                                	Sebring                                 
224	Chrysler                                	Town & Country                          
225	Chrysler                                	Voyager                                 
226	Citroen                                 	Berlingo                                
227	Citroen                                 	C-Crosser                               
228	Citroen                                 	C-Elysee                                
229	Citroen                                 	C1                                      
230	Citroen                                 	C2                                      
231	Citroen                                 	C3                                      
232	Citroen                                 	C3 Aircross                             
233	Citroen                                 	C3 Picasso                              
234	Citroen                                 	C3 Pluriel                              
235	Citroen                                 	C4                                      
236	Citroen                                 	C4 Aircross                             
237	Citroen                                 	C4 Cactus                               
238	Citroen                                 	C4 Picasso                              
239	Citroen                                 	C5                                      
240	Citroen                                 	C6                                      
241	Citroen                                 	C8                                      
242	Citroen                                 	DS 7 Crossback                          
243	Citroen                                 	DS3                                     
244	Citroen                                 	DS4                                     
245	Citroen                                 	DS5                                     
246	Citroen                                 	Grand C4 Picasso                        
247	Citroen                                 	Jumpy                                   
248	Citroen                                 	Nemo                                    
249	Citroen                                 	Saxo                                    
250	Citroen                                 	Spacetourer                             
251	Citroen                                 	Xsara                                   
252	Citroen                                 	Xsara Picasso                           
253	Daewoo                                  	Evanda                                  
254	Daewoo                                  	Kalos                                   
255	Daewoo                                  	Leganza                                 
256	Daewoo                                  	Magnus                                  
257	Daewoo                                  	Matiz                                   
258	Daewoo                                  	Nexia                                   
259	Daewoo                                  	Nubira                                  
260	Daihatsu                                	Applause                                
261	Daihatsu                                	Cast                                    
262	Daihatsu                                	Copen                                   
263	Daihatsu                                	Cuore                                   
264	Daihatsu                                	Gran Move                               
265	Daihatsu                                	Luxio                                   
266	Daihatsu                                	Materia                                 
267	Daihatsu                                	Mebius                                  
268	Daihatsu                                	Move                                    
269	Daihatsu                                	Rocky                                   
270	Daihatsu                                	Sirion                                  
271	Daihatsu                                	Terios                                  
272	Daihatsu                                	Trevis                                  
273	Daihatsu                                	YRV                                     
274	Datsun                                  	mi-DO                                   
275	Datsun                                  	on-DO                                   
276	Dodge                                   	Avenger                                 
277	Dodge                                   	Caliber                                 
278	Dodge                                   	Caliber SRT4                            
279	Dodge                                   	Caravan                                 
280	Dodge                                   	Challenger                              
281	Dodge                                   	Charger                                 
282	Dodge                                   	Dakota                                  
283	Dodge                                   	Dart                                    
284	Dodge                                   	Durango                                 
285	Dodge                                   	Intrepid                                
286	Dodge                                   	Journey                                 
287	Dodge                                   	Magnum                                  
288	Dodge                                   	Neon                                    
289	Dodge                                   	Nitro                                   
290	Dodge                                   	Ram 1500                                
291	Dodge                                   	Ram 2500                                
292	Dodge                                   	Ram 3500                                
293	Dodge                                   	Ram SRT10                               
294	Dodge                                   	Stratus                                 
295	Dodge                                   	Viper                                   
296	Dongfeng                                	580                                     
297	Dongfeng                                	A30                                     
298	Dongfeng                                	AX7                                     
299	Dongfeng                                	H30 Cross                               
300	FAW                                     	Besturn B30                             
301	FAW                                     	Besturn B50                             
302	FAW                                     	Besturn X40                             
303	FAW                                     	Besturn X80                             
304	FAW                                     	Oley                                    
305	FAW                                     	Vita                                    
306	Ferrari                                 	348                                     
307	Ferrari                                 	360                                     
308	Ferrari                                 	456                                     
309	Ferrari                                 	458                                     
310	Ferrari                                 	488                                     
311	Ferrari                                 	512                                     
312	Ferrari                                 	550                                     
313	Ferrari                                 	575 M                                   
314	Ferrari                                 	599 GTB Fiorano                         
315	Ferrari                                 	599 GTO                                 
316	Ferrari                                 	612                                     
317	Ferrari                                 	812                                     
318	Ferrari                                 	California                              
319	Ferrari                                 	California T                            
320	Ferrari                                 	Challenge Stradale                      
321	Ferrari                                 	Enzo                                    
322	Ferrari                                 	F12                                     
323	Ferrari                                 	F355                                    
324	Ferrari                                 	F430                                    
325	Ferrari                                 	F50                                     
326	Ferrari                                 	F512 M                                  
327	Ferrari                                 	FF                                      
328	Ferrari                                 	GTC4 Lusso                              
329	Ferrari                                 	LaFerrari                               
330	Fiat                                    	124 Spider                              
331	Fiat                                    	500                                     
332	Fiat                                    	500L                                    
333	Fiat                                    	500X                                    
334	Fiat                                    	Albea                                   
335	Fiat                                    	Brava                                   
336	Fiat                                    	Bravo                                   
337	Fiat                                    	Coupe                                   
338	Fiat                                    	Croma                                   
339	Fiat                                    	Doblo                                   
340	Fiat                                    	Ducato                                  
341	Fiat                                    	Freemont                                
342	Fiat                                    	Grande Punto                            
343	Fiat                                    	Idea                                    
344	Fiat                                    	Linea                                   
345	Fiat                                    	Marea                                   
346	Fiat                                    	Multipla                                
347	Fiat                                    	Palio                                   
348	Fiat                                    	Panda                                   
349	Fiat                                    	Panda 4x4                               
350	Fiat                                    	Punto                                   
351	Fiat                                    	Qubo                                    
352	Fiat                                    	Sedici                                  
353	Fiat                                    	Siena                                   
354	Fiat                                    	Stilo                                   
355	Fiat                                    	Strada                                  
356	Fiat                                    	Tipo                                    
357	Fiat                                    	Ulysse                                  
358	Fisker                                  	Karma                                   
359	Ford                                    	B-Max                                   
360	Ford                                    	C-Max                                   
361	Ford                                    	Cougar                                  
362	Ford                                    	Crown Victoria                          
363	Ford                                    	EcoSport                                
364	Ford                                    	Edge                                    
365	Ford                                    	Escape                                  
366	Ford                                    	Excursion                               
367	Ford                                    	Expedition                              
368	Ford                                    	Explorer                                
369	Ford                                    	Explorer Sport Trac                     
370	Ford                                    	F-150                                   
371	Ford                                    	F-250                                   
372	Ford                                    	F-350                                   
373	Ford                                    	Falcon                                  
374	Ford                                    	Fiesta                                  
375	Ford                                    	Five Hundred                            
376	Ford                                    	Flex                                    
377	Ford                                    	Focus                                   
378	Ford                                    	Focus Active                            
379	Ford                                    	Freestar                                
380	Ford                                    	Freestyle                               
381	Ford                                    	Fusion                                  
382	Ford                                    	Galaxy                                  
383	Ford                                    	Ka                                      
384	Ford                                    	Kuga                                    
385	Ford                                    	Maverick                                
386	Ford                                    	Mondeo                                  
387	Ford                                    	Mustang                                 
388	Ford                                    	Mustang Shelby GT350                    
389	Ford                                    	Mustang Shelby GT500                    
390	Ford                                    	Puma                                    
391	Ford                                    	Ranger                                  
392	Ford                                    	S-Max                                   
393	Ford                                    	Taurus                                  
394	Ford                                    	Taurus X                                
395	Ford                                    	Thunderbird                             
396	Ford                                    	Tourneo Connect                         
397	Ford                                    	Transit                                 
398	Ford                                    	Transit Connect                         
399	GAZ                                     	3102                                    
400	GAZ                                     	31105                                   
401	GAZ                                     	Siber                                   
402	GAZ                                     	Sobol                                   
403	Geely                                   	Atlas                                   
404	Geely                                   	Coolray                                 
405	Geely                                   	Emgrand 7                               
406	Geely                                   	Emgrand EC7                             
407	Geely                                   	Emgrand GS                              
408	Geely                                   	Emgrand X7                              
409	Geely                                   	GC9                                     
410	Geely                                   	GР РЋ6                                  
411	Geely                                   	MK                                      
412	Geely                                   	Otaka                                   
413	Geely                                   	Vision                                  
414	Genesis                                 	G70                                     
415	Genesis                                 	G80                                     
416	Genesis                                 	G90                                     
417	GMC                                     	Acadia                                  
418	GMC                                     	Canyon                                  
419	GMC                                     	Envoy                                   
420	GMC                                     	Sierra 1500                             
421	GMC                                     	Sierra 2500                             
422	GMC                                     	Terrain                                 
423	GMC                                     	Yukon                                   
424	Great Wall                              	Cowry                                   
425	Great Wall                              	Deer                                    
426	Great Wall                              	Hover                                   
427	Great Wall                              	Hover M2                                
428	Great Wall                              	Pegasus                                 
429	Great Wall                              	Peri                                    
430	Great Wall                              	Safe                                    
431	Great Wall                              	Sailor                                  
432	Great Wall                              	Sing                                    
433	Great Wall                              	Socool                                  
434	Great Wall                              	Wingle                                  
435	Haval                                   	F7                                      
436	Haval                                   	H4                                      
437	Haval                                   	H6                                      
438	Haval                                   	H9                                      
439	Holden                                  	Commodore                               
440	Honda                                   	Accord                                  
441	Honda                                   	Amaze                                   
442	Honda                                   	City                                    
443	Honda                                   	Civic                                   
444	Honda                                   	CR-V                                    
445	Honda                                   	CR-Z                                    
446	Honda                                   	Crosstour                               
447	Honda                                   	Element                                 
448	Honda                                   	Fit                                     
449	Honda                                   	FR-V                                    
450	Honda                                   	HR-V                                    
451	Honda                                   	HR-V II (GJ)                            
452	Honda                                   	Insight                                 
453	Honda                                   	Jade                                    
454	Honda                                   	Jazz                                    
455	Honda                                   	Legend                                  
456	Honda                                   	Odyssey                                 
457	Honda                                   	Pilot                                   
458	Honda                                   	Prelude                                 
459	Honda                                   	Ridgeline                               
460	Honda                                   	S2000                                   
461	Honda                                   	Shuttle                                 
462	Honda                                   	Stream                                  
463	Honda                                   	Vezel                                   
464	Hummer                                  	H1                                      
465	Hummer                                  	H2                                      
466	Hummer                                  	H3                                      
467	Hyundai                                 	Accent                                  
468	Hyundai                                 	Atos Prime                              
469	Hyundai                                 	Azera                                   
470	Hyundai                                 	Centennial                              
471	Hyundai                                 	Creta                                   
472	Hyundai                                 	Elantra                                 
473	Hyundai                                 	Entourage                               
474	Hyundai                                 	Eon                                     
475	Hyundai                                 	Equus                                   
476	Hyundai                                 	Galloper                                
477	Hyundai                                 	Genesis                                 
478	Hyundai                                 	Genesis Coupe                           
479	Hyundai                                 	Getz                                    
480	Hyundai                                 	Grandeur                                
481	Hyundai                                 	H-1                                     
482	Hyundai                                 	i10                                     
483	Hyundai                                 	i20                                     
484	Hyundai                                 	i30                                     
485	Hyundai                                 	i30 N                                   
486	Hyundai                                 	i40                                     
487	Hyundai                                 	Ioniq                                   
488	Hyundai                                 	ix20                                    
489	Hyundai                                 	ix35                                    
490	Hyundai                                 	Kona                                    
491	Hyundai                                 	Matrix                                  
492	Hyundai                                 	Palisade                                
493	Hyundai                                 	Porter                                  
494	Hyundai                                 	Santa Fe                                
495	Hyundai                                 	Solaris                                 
496	Hyundai                                 	Sonata                                  
497	Hyundai                                 	Terracan                                
498	Hyundai                                 	Trajet                                  
499	Hyundai                                 	Tucson                                  
500	Hyundai                                 	Veloster                                
501	Hyundai                                 	Veracruz                                
502	Hyundai                                 	Verna                                   
503	Hyundai                                 	Xcent                                   
504	Hyundai                                 	XG                                      
505	Infiniti                                	EX                                      
506	Infiniti                                	FX                                      
507	Infiniti                                	G                                       
508	Infiniti                                	I35                                     
509	Infiniti                                	JX                                      
510	Infiniti                                	M                                       
511	Infiniti                                	Q30                                     
512	Infiniti                                	Q40                                     
513	Infiniti                                	Q45                                     
514	Infiniti                                	Q50                                     
515	Infiniti                                	Q60                                     
516	Infiniti                                	Q70                                     
517	Infiniti                                	QX30                                    
518	Infiniti                                	QX4                                     
519	Infiniti                                	QX50                                    
520	Infiniti                                	QX56                                    
521	Infiniti                                	QX60                                    
522	Infiniti                                	QX70                                    
523	Infiniti                                	QX80                                    
524	Isuzu                                   	Ascender                                
525	Isuzu                                   	Axiom                                   
526	Isuzu                                   	D-Max                                   
527	Isuzu                                   	D-Max Rodeo                             
528	Isuzu                                   	I280                                    
529	Isuzu                                   	I290                                    
530	Isuzu                                   	I350                                    
531	Isuzu                                   	I370                                    
532	Isuzu                                   	Rodeo                                   
533	Isuzu                                   	Trooper                                 
534	Isuzu                                   	VehiCross                               
535	Iveco                                   	Daily                                   
536	Jaguar                                  	E-Pace                                  
537	Jaguar                                  	F-Pace                                  
538	Jaguar                                  	F-Type                                  
539	Jaguar                                  	I-Pace                                  
540	Jaguar                                  	S-Type                                  
541	Jaguar                                  	X-Type                                  
542	Jaguar                                  	XE                                      
543	Jaguar                                  	XF                                      
544	Jaguar                                  	XJ                                      
545	Jaguar                                  	XK/XKR                                  
546	Jeep                                    	Cherokee                                
547	Jeep                                    	Commander                               
548	Jeep                                    	Compass                                 
549	Jeep                                    	Gladiator                               
550	Jeep                                    	Grand Cherokee                          
551	Jeep                                    	Liberty                                 
552	Jeep                                    	Patriot                                 
553	Jeep                                    	Renegade                                
554	Jeep                                    	Wrangler                                
555	Kia                                     	Carens                                  
556	Kia                                     	Carnival                                
557	Kia                                     	Ceed                                    
558	Kia                                     	Cerato                                  
559	Kia                                     	Clarus                                  
560	Kia                                     	Forte                                   
561	Kia                                     	K900                                    
562	Kia                                     	Magentis                                
563	Kia                                     	Mohave                                  
564	Kia                                     	Niro                                    
565	Kia                                     	Opirus                                  
566	Kia                                     	Optima                                  
567	Kia                                     	Picanto                                 
568	Kia                                     	ProCeed                                 
569	Kia                                     	Quoris                                  
570	Kia                                     	Ray                                     
571	Kia                                     	Rio                                     
572	Kia                                     	Rio X-Line                              
573	Kia                                     	Seltos                                  
574	Kia                                     	Shuma                                   
575	Kia                                     	Sorento                                 
576	Kia                                     	Sorento Prime                           
577	Kia                                     	Soul                                    
578	Kia                                     	Spectra                                 
579	Kia                                     	Sportage                                
580	Kia                                     	Stinger                                 
581	Kia                                     	Stonic                                  
582	Kia                                     	Telluride                               
583	Kia                                     	Venga                                   
584	Lamborghini                             	Aventador                               
585	Lamborghini                             	Centenario                              
586	Lamborghini                             	Diablo                                  
587	Lamborghini                             	Gallardo                                
588	Lamborghini                             	Huracan                                 
589	Lamborghini                             	Murcielago                              
590	Lamborghini                             	Reventon                                
591	Lamborghini                             	Urus                                    
592	Lancia                                  	Delta                                   
593	Lancia                                  	Lybra                                   
594	Lancia                                  	Musa                                    
595	Lancia                                  	Phedra                                  
596	Lancia                                  	Thema                                   
597	Lancia                                  	Thesis                                  
598	Lancia                                  	Ypsilon                                 
599	Land Rover                              	Defender                                
600	Land Rover                              	Discovery                               
601	Land Rover                              	Discovery Sport                         
602	Land Rover                              	Evoque                                  
603	Land Rover                              	Freelander                              
604	Land Rover                              	Range Rover                             
605	Land Rover                              	Range Rover Sport                       
606	Land Rover                              	Range Rover Velar                       
607	Lexus                                   	CT                                      
608	Lexus                                   	ES                                      
609	Lexus                                   	GS                                      
610	Lexus                                   	GX                                      
611	Lexus                                   	HS                                      
612	Lexus                                   	IS                                      
613	Lexus                                   	LC                                      
614	Lexus                                   	LFA                                     
615	Lexus                                   	LS                                      
616	Lexus                                   	LX                                      
617	Lexus                                   	NX                                      
618	Lexus                                   	RC                                      
619	Lexus                                   	RX                                      
620	Lexus                                   	SC                                      
621	Lexus                                   	UX                                      
622	Lifan                                   	Breez                                   
623	Lifan                                   	Cebrium                                 
624	Lifan                                   	Celliya                                 
625	Lifan                                   	Smily                                   
626	Lifan                                   	Solano                                  
627	Lifan                                   	X50                                     
628	Lifan                                   	X60                                     
629	Lincoln                                 	Aviator                                 
630	Lincoln                                 	Corsair                                 
631	Lincoln                                 	Mark LT                                 
632	Lincoln                                 	MKC                                     
633	Lincoln                                 	MKS                                     
634	Lincoln                                 	MKT                                     
635	Lincoln                                 	MKX                                     
636	Lincoln                                 	MKZ                                     
637	Lincoln                                 	Navigator                               
638	Lincoln                                 	Town Car                                
639	Lincoln                                 	Zephyr                                  
640	Lotus                                   	Elise                                   
641	Lotus                                   	Europa S                                
642	Lotus                                   	Evora                                   
643	Lotus                                   	Exige                                   
644	Marussia                                	B1                                      
645	Marussia                                	B2                                      
646	Maserati                                	3200 GT                                 
647	Maserati                                	Ghibli                                  
648	Maserati                                	Gran Cabrio                             
649	Maserati                                	Gran Turismo                            
650	Maserati                                	Gran Turismo S                          
651	Maserati                                	Levante                                 
652	Maserati                                	Quattroporte                            
653	Maserati                                	Quattroporte S                          
654	Maybach                                 	57                                      
655	Maybach                                 	57 S                                    
656	Maybach                                 	62                                      
657	Maybach                                 	62 S                                    
658	Maybach                                 	Landaulet                               
659	Mazda                                   	2                                       
660	Mazda                                   	3                                       
661	Mazda                                   	323                                     
662	Mazda                                   	5                                       
663	Mazda                                   	6                                       
664	Mazda                                   	626                                     
665	Mazda                                   	B-Series                                
666	Mazda                                   	BT-50                                   
667	Mazda                                   	CX-3                                    
668	Mazda                                   	CX-5                                    
669	Mazda                                   	CX-7                                    
670	Mazda                                   	CX-9                                    
671	Mazda                                   	MPV                                     
672	Mazda                                   	MX-5                                    
673	Mazda                                   	Premacy                                 
674	Mazda                                   	RX-7                                    
675	Mazda                                   	RX-8                                    
676	Mazda                                   	Tribute                                 
677	McLaren                                 	540C                                    
678	McLaren                                 	570S                                    
679	McLaren                                 	600LT                                   
680	McLaren                                 	650S                                    
681	McLaren                                 	675LT                                   
682	McLaren                                 	720S                                    
683	McLaren                                 	MP4-12C                                 
684	McLaren                                 	P1                                      
685	Mercedes                                	A-class                                 
686	Mercedes                                	AMG GT                                  
687	Mercedes                                	AMG GT 4-Door                           
688	Mercedes                                	B-class                                 
689	Mercedes                                	C-class                                 
690	Mercedes                                	C-class Sport Coupe                     
691	Mercedes                                	CL-class                                
692	Mercedes                                	CLA-class                               
693	Mercedes                                	CLC-class                               
694	Mercedes                                	CLK-class                               
695	Mercedes                                	CLS-class                               
696	Mercedes                                	E-class                                 
697	Mercedes                                	E-class Coupe                           
698	Mercedes                                	EQC                                     
699	Mercedes                                	G-class                                 
700	Mercedes                                	GL-class                                
701	Mercedes                                	GLA-class                               
702	Mercedes                                	GLB-class                               
703	Mercedes                                	GLC-class                               
704	Mercedes                                	GLC-class Coupe                         
705	Mercedes                                	GLE-class                               
706	Mercedes                                	GLE-class Coupe                         
707	Mercedes                                	GLK-class                               
708	Mercedes                                	GLS-class                               
709	Mercedes                                	M-class                                 
710	Mercedes                                	R-class                                 
711	Mercedes                                	S-class                                 
712	Mercedes                                	S-class Cabrio                          
713	Mercedes                                	S-class Coupe                           
714	Mercedes                                	SL-class                                
715	Mercedes                                	SLK-class                               
716	Mercedes                                	SLR-class                               
717	Mercedes                                	SLS AMG                                 
718	Mercedes                                	Sprinter                                
719	Mercedes                                	Vaneo                                   
720	Mercedes                                	Viano                                   
721	Mercedes                                	Vito                                    
722	Mercedes                                	X-class                                 
723	Mercury                                 	Grand Marquis                           
724	Mercury                                 	Mariner                                 
725	Mercury                                 	Milan                                   
726	Mercury                                 	Montego                                 
727	Mercury                                 	Monterey                                
728	Mercury                                 	Mountaineer                             
729	Mercury                                 	Sable                                   
730	MG                                      	TF                                      
731	MG                                      	XPower SV                               
732	MG                                      	ZR                                      
733	MG                                      	ZS                                      
734	MG                                      	ZT                                      
735	MG                                      	ZT-T                                    
736	Mini                                    	Clubman                                 
737	Mini                                    	Clubman S                               
738	Mini                                    	Clubvan                                 
739	Mini                                    	Cooper                                  
740	Mini                                    	Cooper Cabrio                           
741	Mini                                    	Cooper S                                
742	Mini                                    	Cooper S Cabrio                         
743	Mini                                    	Cooper S Countryman All4                
744	Mini                                    	Countryman                              
745	Mini                                    	One                                     
746	Mitsubishi                              	3000 GT                                 
747	Mitsubishi                              	ASX                                     
748	Mitsubishi                              	Carisma                                 
749	Mitsubishi                              	Colt                                    
750	Mitsubishi                              	Dignity                                 
751	Mitsubishi                              	Eclipse                                 
752	Mitsubishi                              	Eclipse Cross                           
753	Mitsubishi                              	Endeavor                                
754	Mitsubishi                              	Galant                                  
755	Mitsubishi                              	Grandis                                 
756	Mitsubishi                              	i-MiEV                                  
757	Mitsubishi                              	L200                                    
758	Mitsubishi                              	Lancer                                  
759	Mitsubishi                              	Lancer Evo                              
760	Mitsubishi                              	Mirage                                  
761	Mitsubishi                              	Outlander                               
762	Mitsubishi                              	Outlander XL                            
763	Mitsubishi                              	Pajero                                  
764	Mitsubishi                              	Pajero Pinin                            
765	Mitsubishi                              	Pajero Sport                            
766	Mitsubishi                              	Raider                                  
767	Mitsubishi                              	Space Gear                              
768	Mitsubishi                              	Space Runner                            
769	Mitsubishi                              	Space Star                              
770	Nissan                                  	350Z                                    
771	Nissan                                  	370Z                                    
772	Nissan                                  	Almera                                  
773	Nissan                                  	Almera Classic                          
774	Nissan                                  	Almera Tino                             
775	Nissan                                  	Altima                                  
776	Nissan                                  	Armada                                  
777	Nissan                                  	Bluebird Sylphy                         
778	Nissan                                  	GT-R                                    
779	Nissan                                  	Juke                                    
780	Nissan                                  	Leaf                                    
781	Nissan                                  	Maxima                                  
782	Nissan                                  	Micra                                   
783	Nissan                                  	Murano                                  
784	Nissan                                  	Navara                                  
785	Nissan                                  	Note                                    
786	Nissan                                  	NP300                                   
787	Nissan                                  	Pathfinder                              
788	Nissan                                  	Patrol                                  
789	Nissan                                  	Primera                                 
790	Nissan                                  	Qashqai                                 
791	Nissan                                  	Qashqai+2                               
792	Nissan                                  	Quest                                   
793	Nissan                                  	Rogue                                   
794	Nissan                                  	Sentra                                  
795	Nissan                                  	Skyline                                 
796	Nissan                                  	Sylphy                                  
797	Nissan                                  	Teana                                   
798	Nissan                                  	Terrano                                 
799	Nissan                                  	Tiida                                   
800	Nissan                                  	Titan                                   
801	Nissan                                  	Titan XD                                
802	Nissan                                  	X-Trail                                 
803	Nissan                                  	XTerra                                  
804	Nissan                                  	Z                                       
805	Noble                                   	M600                                    
806	Opel                                    	Adam                                    
807	Opel                                    	Agila                                   
808	Opel                                    	Antara                                  
809	Opel                                    	Astra                                   
810	Opel                                    	Astra GTS                               
811	Opel                                    	Cascada                                 
812	Opel                                    	Combo                                   
813	Opel                                    	Corsa                                   
814	Opel                                    	Corsa OPC                               
815	Opel                                    	Crossland X                             
816	Opel                                    	Frontera                                
817	Opel                                    	Grandland X                             
818	Opel                                    	Insignia                                
819	Opel                                    	Insignia OPC                            
820	Opel                                    	Karl                                    
821	Opel                                    	Meriva                                  
822	Opel                                    	Mokka                                   
823	Opel                                    	Omega                                   
824	Opel                                    	Signum                                  
825	Opel                                    	Speedster                               
826	Opel                                    	Tigra                                   
827	Opel                                    	Vectra                                  
828	Opel                                    	Vivaro                                  
829	Opel                                    	Zafira                                  
830	Opel                                    	Zafira Tourer                           
831	Peugeot                                 	1007                                    
832	Peugeot                                 	107                                     
833	Peugeot                                 	108                                     
834	Peugeot                                 	2008                                    
835	Peugeot                                 	206                                     
836	Peugeot                                 	207                                     
837	Peugeot                                 	208                                     
838	Peugeot                                 	3008                                    
839	Peugeot                                 	301                                     
840	Peugeot                                 	307                                     
841	Peugeot                                 	308                                     
842	Peugeot                                 	4007                                    
843	Peugeot                                 	4008                                    
844	Peugeot                                 	406                                     
845	Peugeot                                 	407                                     
846	Peugeot                                 	408                                     
847	Peugeot                                 	5008                                    
848	Peugeot                                 	508                                     
849	Peugeot                                 	607                                     
850	Peugeot                                 	807                                     
851	Peugeot                                 	Boxer                                   
852	Peugeot                                 	Partner                                 
853	Peugeot                                 	RCZ Sport                               
854	Plymouth                                	Road Runner                             
855	Pontiac                                 	Aztec                                   
856	Pontiac                                 	Bonneville                              
857	Pontiac                                 	Firebird                                
858	Pontiac                                 	G5 Pursuit                              
859	Pontiac                                 	G6                                      
860	Pontiac                                 	G8                                      
861	Pontiac                                 	Grand AM                                
862	Pontiac                                 	Grand Prix                              
863	Pontiac                                 	GTO                                     
864	Pontiac                                 	Montana                                 
865	Pontiac                                 	Solstice                                
866	Pontiac                                 	Sunfire                                 
867	Pontiac                                 	Torrent                                 
868	Pontiac                                 	Vibe                                    
869	Porsche                                 	718 Boxster                             
870	Porsche                                 	718 Cayman                              
871	Porsche                                 	911                                     
872	Porsche                                 	Boxster                                 
873	Porsche                                 	Cayenne                                 
874	Porsche                                 	Cayman                                  
875	Porsche                                 	Macan                                   
876	Porsche                                 	Panamera                                
877	Porsche                                 	Taycan                                  
878	Ravon                                   	Gentra                                  
879	Renault                                 	Arkana                                  
880	Renault                                 	Avantime                                
881	Renault                                 	Captur                                  
882	Renault                                 	Clio                                    
883	Renault                                 	Duster                                  
884	Renault                                 	Duster Oroch                            
885	Renault                                 	Espace                                  
886	Renault                                 	Fluence                                 
887	Renault                                 	Grand Scenic                            
888	Renault                                 	Kadjar                                  
889	Renault                                 	Kangoo                                  
890	Renault                                 	Kaptur                                  
891	Renault                                 	Koleos                                  
892	Renault                                 	Laguna                                  
893	Renault                                 	Latitude                                
894	Renault                                 	Logan                                   
895	Renault                                 	Master                                  
896	Renault                                 	Megane                                  
897	Renault                                 	Modus                                   
898	Renault                                 	Sandero                                 
899	Renault                                 	Sandero Stepway                         
900	Renault                                 	Scenic                                  
901	Renault                                 	Symbol                                  
902	Renault                                 	Talisman                                
903	Renault                                 	Trafic                                  
904	Renault                                 	Twingo                                  
905	Renault                                 	Twizy                                   
906	Renault                                 	Vel Satis                               
907	Renault                                 	Wind                                    
908	Renault                                 	Zoe                                     
909	Rolls-Royce                             	Cullinan                                
910	Rolls-Royce                             	Dawn                                    
911	Rolls-Royce                             	Ghost                                   
912	Rolls-Royce                             	Phantom                                 
913	Rolls-Royce                             	Wraith                                  
914	Rover                                   	25                                      
915	Rover                                   	400                                     
916	Rover                                   	45                                      
917	Rover                                   	600                                     
918	Rover                                   	75                                      
919	Rover                                   	Streetwise                              
920	Saab                                    	9-2x                                    
921	Saab                                    	44264                                   
922	Saab                                    	9-4x                                    
923	Saab                                    	44325                                   
924	Saab                                    	9-7x                                    
925	Saturn                                  	Aura                                    
926	Saturn                                  	Ion                                     
927	Saturn                                  	LW                                      
928	Saturn                                  	Outlook                                 
929	Saturn                                  	Sky                                     
930	Saturn                                  	Vue                                     
931	Scion                                   	FR-S                                    
932	Scion                                   	tC                                      
933	Scion                                   	xA                                      
934	Scion                                   	xB                                      
935	Scion                                   	xD                                      
936	Seat                                    	Alhambra                                
937	Seat                                    	Altea                                   
938	Seat                                    	Altea Freetrack                         
939	Seat                                    	Altea XL                                
940	Seat                                    	Arosa                                   
941	Seat                                    	Ateca                                   
942	Seat                                    	Cordoba                                 
943	Seat                                    	Exeo                                    
944	Seat                                    	Ibiza                                   
945	Seat                                    	Leon                                    
946	Seat                                    	Mii                                     
947	Seat                                    	Toledo                                  
948	Skoda                                   	Citigo                                  
949	Skoda                                   	Fabia                                   
950	Skoda                                   	Felicia                                 
951	Skoda                                   	Kamiq                                   
952	Skoda                                   	Karoq                                   
953	Skoda                                   	Kodiaq                                  
954	Skoda                                   	Octavia                                 
955	Skoda                                   	Octavia Scout                           
956	Skoda                                   	Octavia Tour                            
957	Skoda                                   	Praktik                                 
958	Skoda                                   	Rapid                                   
959	Skoda                                   	Rapid Spaceback (NH1)                   
960	Skoda                                   	Roomster                                
961	Skoda                                   	Superb                                  
962	Skoda                                   	Yeti                                    
963	Smart                                   	Forfour                                 
964	Smart                                   	Fortwo                                  
965	Smart                                   	Roadster                                
966	Ssang Yong                              	Actyon                                  
967	Ssang Yong                              	Actyon Sports                           
968	Ssang Yong                              	Chairman                                
969	Ssang Yong                              	Korando                                 
970	Ssang Yong                              	Kyron                                   
971	Ssang Yong                              	Musso                                   
972	Ssang Yong                              	Musso Sport                             
973	Ssang Yong                              	Rexton                                  
974	Ssang Yong                              	Rodius                                  
975	Ssang Yong                              	Stavic                                  
976	Ssang Yong                              	Tivoli                                  
977	Ssang Yong                              	XLV                                     
978	Subaru                                  	Ascent                                  
979	Subaru                                  	Baja                                    
980	Subaru                                  	Crosstrack                              
981	Subaru                                  	Exiga                                   
982	Subaru                                  	Forester                                
983	Subaru                                  	Impreza                                 
984	Subaru                                  	Justy                                   
985	Subaru                                  	Legacy                                  
986	Subaru                                  	Levorg                                  
987	Subaru                                  	Outback                                 
988	Subaru                                  	Traviq                                  
989	Subaru                                  	Tribeca                                 
990	Subaru                                  	WRX                                     
991	Subaru                                  	XV                                      
992	Suzuki                                  	Alto                                    
993	Suzuki                                  	Baleno                                  
994	Suzuki                                  	Celerio                                 
995	Suzuki                                  	Ciaz                                    
996	Suzuki                                  	Grand Vitara                            
997	Suzuki                                  	Grand Vitara XL7                        
998	Suzuki                                  	Ignis                                   
999	Suzuki                                  	Jimny                                   
1000	Suzuki                                  	Kizashi                                 
1001	Suzuki                                  	Liana                                   
1002	Suzuki                                  	Splash                                  
1003	Suzuki                                  	Swift                                   
1004	Suzuki                                  	SX4                                     
1005	Suzuki                                  	Vitara                                  
1006	Suzuki                                  	Wagon R                                 
1007	Suzuki                                  	Wagon R+                                
1008	Tesla                                   	Model 3                                 
1009	Tesla                                   	Model S                                 
1010	Tesla                                   	Model X                                 
1011	Tesla                                   	Model Y                                 
1012	Toyota                                  	4Runner                                 
1013	Toyota                                  	Alphard                                 
1014	Toyota                                  	Auris                                   
1015	Toyota                                  	Avalon                                  
1016	Toyota                                  	Avensis                                 
1017	Toyota                                  	Avensis Verso                           
1018	Toyota                                  	Aygo                                    
1019	Toyota                                  	C-HR                                    
1020	Toyota                                  	Caldina                                 
1021	Toyota                                  	Camry                                   
1022	Toyota                                  	Celica                                  
1023	Toyota                                  	Corolla                                 
1024	Toyota                                  	Corolla Verso                           
1025	Toyota                                  	FJ Cruiser                              
1026	Toyota                                  	Fortuner                                
1027	Toyota                                  	GT 86                                   
1028	Toyota                                  	Hiace                                   
1029	Toyota                                  	Highlander                              
1030	Toyota                                  	Hilux                                   
1031	Toyota                                  	iQ                                      
1032	Toyota                                  	ist                                     
1033	Toyota                                  	Land Cruiser                            
1034	Toyota                                  	Land Cruiser Prado                      
1035	Toyota                                  	Mark II                                 
1036	Toyota                                  	Mirai                                   
1037	Toyota                                  	MR2                                     
1038	Toyota                                  	Picnic                                  
1039	Toyota                                  	Previa                                  
1040	Toyota                                  	Prius                                   
1041	Toyota                                  	RAV4                                    
1042	Toyota                                  	Sequoia                                 
1043	Toyota                                  	Sienna                                  
1044	Toyota                                  	Supra                                   
1045	Toyota                                  	Tacoma                                  
1046	Toyota                                  	Tundra                                  
1047	Toyota                                  	Venza                                   
1048	Toyota                                  	Verso                                   
1049	Toyota                                  	Vitz                                    
1050	Toyota                                  	Yaris                                   
1051	Toyota                                  	Yaris Verso                             
1052	UAZ                                     	Pickup                                  
1053	UAZ                                     	Hunter                                  
1054	UAZ                                     	452                                     
1055	VAZ                                     	2101-2107                               
1056	VAZ                                     	2108,2109,21099                         
1057	VAZ                                     	2110,2111,2112                          
1058	VAZ                                     	2113,2114,2115                          
1059	VAZ                                     	4x4 Urban                               
1060	VAZ                                     	Granta                                  
1061	VAZ                                     	Largus                                  
1062	VAZ                                     	Largus Cross                            
1063	VAZ                                     	Vesta Cross                             
1064	VAZ                                     	Vesta Sport                             
1065	VAZ                                     	Vesta SW                                
1066	VAZ                                     	XRay                                    
1067	VAZ                                     	XRay Cross                              
1068	VAZ                                     	Priora                                  
1069	VAZ                                     	Kalina                                  
1070	VAZ                                     	2121 4X4                                
1071	VAZ                                     	Niva travel                             
1072	VAZ                                     	Lada Niva                               
1073	Volkswagen                              	Amarok                                  
1074	Volkswagen                              	Arteon                                  
1075	Volkswagen                              	Beetle                                  
1076	Volkswagen                              	Bora                                    
1077	Volkswagen                              	Caddy                                   
1078	Volkswagen                              	CC                                      
1079	Volkswagen                              	Crafter                                 
1080	Volkswagen                              	CrossGolf                               
1081	Volkswagen                              	CrossPolo                               
1082	Volkswagen                              	CrossTouran                             
1083	Volkswagen                              	Eos                                     
1084	Volkswagen                              	Fox                                     
1085	Volkswagen                              	Golf                                    
1086	Volkswagen                              	Jetta                                   
1087	Volkswagen                              	Lupo                                    
1088	Volkswagen                              	Multivan                                
1089	Volkswagen                              	New Beetle                              
1090	Volkswagen                              	Passat                                  
1091	Volkswagen                              	Passat CC                               
1092	Volkswagen                              	Phaeton                                 
1093	Volkswagen                              	Pointer                                 
1094	Volkswagen                              	Polo                                    
1095	Volkswagen                              	Routan                                  
1096	Volkswagen                              	Scirocco                                
1097	Volkswagen                              	Sharan                                  
1098	Volkswagen                              	T-Roc                                   
1099	Volkswagen                              	Teramont                                
1100	Volkswagen                              	Tiguan                                  
1101	Volkswagen                              	Touareg                                 
1102	Volkswagen                              	Touran                                  
1103	Volkswagen                              	Transporter                             
1104	Volkswagen                              	Up                                      
1105	Volvo                                   	C30                                     
1106	Volvo                                   	C70                                     
1107	Volvo                                   	C70 Convertible                         
1108	Volvo                                   	C70 Coupe                               
1109	Volvo                                   	S40                                     
1110	Volvo                                   	S60                                     
1111	Volvo                                   	S70                                     
1112	Volvo                                   	S80                                     
1113	Volvo                                   	S90                                     
1114	Volvo                                   	V40                                     
1115	Volvo                                   	V50                                     
1116	Volvo                                   	V60                                     
1117	Volvo                                   	V70                                     
1118	Volvo                                   	V90                                     
1119	Volvo                                   	XC40                                    
1120	Volvo                                   	XC60                                    
1121	Volvo                                   	XC70                                    
1122	Volvo                                   	XC90                                    
\.


--
-- Data for Name: reestr_nomerov; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reestr_nomerov (id, number, data_vidachi, data_snyatiya, id_auto_rn) FROM stdin;
25	О887ОО98  	2021-12-17	2021-12-31	21
26	В040КО45  	2021-12-16	\N	21
\.


--
-- Data for Name: reestr_vladelcev; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reestr_vladelcev (id, fio, data_postanovki, data_snyatiya, id_auto_rv) FROM stdin;
13	Мишина Василиса Кирилловна                        	2021-12-19	2021-12-19	21
15	Цветков Ибрагил Оскарович                         	2021-12-20	2021-12-18	21
\.


--
-- Name: Auto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Auto_id_seq"', 23, true);


--
-- Name: Avarii_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Avarii_id_seq"', 11, true);


--
-- Name: Model_Marka_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Model_Marka_id_seq"', 1141, true);


--
-- Name: Reestr_Vladelcev_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Reestr_Vladelcev_id_seq"', 15, true);


--
-- Name: Reestr_nomerov_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Reestr_nomerov_id_seq"', 26, true);


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_seq', 21, true);


--
-- Name: model_marka UNIQ; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_marka
    ADD CONSTRAINT "UNIQ" UNIQUE (model);


--
-- Name: auto VINuniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto
    ADD CONSTRAINT "VINuniq" UNIQUE (vin_nomer);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: auto pk1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto
    ADD CONSTRAINT pk1 PRIMARY KEY (id);


--
-- Name: model_marka pk2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_marka
    ADD CONSTRAINT pk2 PRIMARY KEY (id);


--
-- Name: avarii pk3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avarii
    ADD CONSTRAINT pk3 PRIMARY KEY (id);


--
-- Name: reestr_nomerov pk4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_nomerov
    ADD CONSTRAINT pk4 PRIMARY KEY (id);


--
-- Name: reestr_vladelcev pk5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_vladelcev
    ADD CONSTRAINT pk5 PRIMARY KEY (id);


--
-- Name: auto unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto
    ADD CONSTRAINT "unique" UNIQUE (vin_nomer);


--
-- Name: fki_vk1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_vk1 ON public.auto USING btree (id_mm);


--
-- Name: fki_vk2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_vk2 ON public.avarii USING btree (id_auto_av);


--
-- Name: fki_vk3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_vk3 ON public.reestr_vladelcev USING btree (id_auto_rv);


--
-- Name: fki_vk4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_vk4 ON public.reestr_nomerov USING btree (id_auto_rn);


--
-- Name: auto vk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto
    ADD CONSTRAINT vk1 FOREIGN KEY (id_mm) REFERENCES public.model_marka(id);


--
-- Name: avarii vk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avarii
    ADD CONSTRAINT vk2 FOREIGN KEY (id_auto_av) REFERENCES public.auto(id);


--
-- Name: reestr_vladelcev vk3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_vladelcev
    ADD CONSTRAINT vk3 FOREIGN KEY (id_auto_rv) REFERENCES public.auto(id);


--
-- Name: reestr_nomerov vk4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reestr_nomerov
    ADD CONSTRAINT vk4 FOREIGN KEY (id_auto_rn) REFERENCES public.auto(id);


--
-- PostgreSQL database dump complete
--

