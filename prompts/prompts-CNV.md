como arquitecto de sistemas y analista de bases de datos, analiza la estructura de la base de datos del proyecto en contexto.

---

¿eres capaz de ir guardando los prompts que te escribo en el archivo @prompts-CNV.md manteniendo una separacion entre los mismos?

---

Muy bien, esta tarea la tienes que hacer para cada prompt que escriba

---

Seguimos en el contexto que eres un analista de bases de datos.
Ahora te voy a pasar un ERD con nuevas entidades. 
Analizalas y ponlas en contexto junto con las entidades actuales.
No escribas código todavia.

erDiagram
     COMPANY {
         int id PK
         string name
     }
     EMPLOYEE {
         int id PK
         int company_id FK
         string name
         string email
         string role
         boolean is_active
     }
     POSITION {
         int id PK
         int company_id FK
         int interview_flow_id FK
         string title
         text description
         string status
         boolean is_visible
         string location
         text job_description
         text requirements
         text responsibilities
         numeric salary_min
         numeric salary_max
         string employment_type
         text benefits
         text company_description
         date application_deadline
         string contact_info
     }
     INTERVIEW_FLOW {
         int id PK
         string description
     }
     INTERVIEW_STEP {
         int id PK
         int interview_flow_id FK
         int interview_type_id FK
         string name
         int order_index
     }
     INTERVIEW_TYPE {
         int id PK
         string name
         text description
     }
     CANDIDATE {
         int id PK
         string firstName
         string lastName
         string email
         string phone
         string address
     }
     APPLICATION {
         int id PK
         int position_id FK
         int candidate_id FK
         date application_date
         string status
         text notes
     }
     INTERVIEW {
         int id PK
         int application_id FK
         int interview_step_id FK
         int employee_id FK
         date interview_date
         string result
         int score
         text notes
     }

     COMPANY ||--o{ EMPLOYEE : employs
     COMPANY ||--o{ POSITION : offers
     POSITION ||--|| INTERVIEW_FLOW : assigns
     INTERVIEW_FLOW ||--o{ INTERVIEW_STEP : contains
     INTERVIEW_STEP ||--|| INTERVIEW_TYPE : uses
     POSITION ||--o{ APPLICATION : receives
     CANDIDATE ||--o{ APPLICATION : submits
     APPLICATION ||--o{ INTERVIEW : has
     INTERVIEW ||--|| INTERVIEW_STEP : consists_of
     EMPLOYEE ||--o{ INTERVIEW : conducts

---

Estas nuevas entidades deben de permitir operar el flujo completo de aplicación para diversas posiciones.

---

Crea un script SQL a partir del nuevo diagrama ERD que se ha indicado.

---

Ahora necesitamos integrar ese script sql con las entidades iniciales.
La idea es tener la funcionalidad de operar el flujo completo de aplicación para diversas posiciones.

---

aplica a esta estructura de entidades las buenas practicas de normalización pero sin llegar a perder eficiencia por estructurar demasiado las entidades.

---

Revisa la estructura de indices y sugiere que se podria mejorar. aun no escribas codigo

---

procede con los cambios propuestos

---

Analiza la escalabilidad del esquema y sugiere posibles mejoras.
No escribas codigo todavia

---

lo veremos mas adelante cuando hagamos las simulaciones.
Describeme que hacen los triggers

---

Sugiere que consultas podrian ser utiles teniendo en cuenta los indices que se han creado para que las consultas sean optimas y eficientes

---

implementalas en el archivo sql

---

vamos a proceder ahora con la migracion al ORM.
No escribas código todavia.
pregunta las dudas que tengas antes



