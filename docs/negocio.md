Resumen Reunión de Descubrimiento del Negocio ACB

## **1. Flujo de inscripción y operación actual**

1. **Llegada del alumno:**

   * El alumno llega y se le ofrecen paquetes de cursos:

     * 10 horas prácticas + 6 horas teóricas.
     * 14 horas prácticas + 6 horas teóricas.
     * Ejecutivo: fines de semana (sábado y domingo), 10 o 14 horas según modalidad.
     * Curso de moto: 10 horas prácticas + 6 teóricas.
   * Se explican características:

     * Vehículo de doble mando.
     * Instructor asignado.
     * Evolución gradual: lugar vacío → tráfico lento → tráfico pesado.
     * Clases teóricas: educación vial, mecánica básica, primeros auxilios.
     * Clases prácticas personalizadas según avance.
     * Posibilidad de clase final en automático.

2. **Selección de horarios:**

   * Horarios disponibles:

     * Mañana: 8-10, 10-12.
     * Tarde: 13-15, 15-17, 17-19.
   * Horarios abiertos y flexibles, no se manejan exámenes aún.
   * Horario final depende de disponibilidad de vehículos y profesores.

3. **Proceso de inscripción y pago:**

   * Datos requeridos del alumno:

     * Nombre completo
     * Número de carnet
     * Fecha de nacimiento
     * Teléfono
     * Correo electrónico (opcional)
     * Foto (opcional)
     * **Nota importante:** La diferencia de restricciones entre menores y mayores es una decisión física/legal externa al sistema. El sistema NO requiere datos especiales de tutor, documento de compromiso ni validaciones basadas en edad.
   * Pagos:

     * **Validación de pago:** Realizada EXTERNA al sistema (mostrador, QR, efectivo, transferencia)
     * **Confirmación en sistema:** El inscriptor confirma el pago en el sistema estableciendo estado_pago='completado' en la inscripción
     * Forma de pago: QR o efectivo (gestión física externa)
     * Pago único por curso
     * Número de factura/comprobante (referencia externa)
   * Registro y control:

     * Inscripción realizada en 3 computadoras
     * Sistema sincroniza automáticamente
     * Validación de datos al ingresar: nombre, número carnet, teléfono, fecha nacimiento

4. **Asignación de recursos:**

   * Vehículos: 4 (3 manuales, 1 automático)
   * Profesores: 5 en total
   * Horarios y espacios reservados en tabla tipo Excel
   * Problemas frecuentes:

     * Doble inscripción en mismo horario y vehículo
     * Rotación del vehículo automático

5. **Seguimiento:**

   * Registro de clases por alumno en hoja de horario
   * Plan de respaldo manual en caso de fallo del sistema
   * Estadísticas de pagos acumuladas por mes
   * Listado de alumnos inscritos y sus pagos

---

## **2. Roles y responsabilidades**

* **Director de escuela:** supervisa proceso y puede inscribir.
* **Asistente de licencias internas:** colabora en inscripciones.
* **Asistente de la escuela (call center):** controla horarios y grúas.
* **Encargada Lizette:** gestión de vehículos y horarios.
* **Notas:**

  * Cuatro personas tienen permiso de inscripción.
  * Tres computadoras disponibles para registro simultáneo.

---

## **3. Datos clave para el software**

1. **Alumno:**

   * Nombre completo
   * Fecha de nacimiento (para referencia, NO para bifurcación lógica)
   * Número de carnet (identificador único)
   * Teléfono
   * Correo electrónico (opcional)
   * Foto (opcional)
   * **No se almacenan:** datos de tutor, documento de compromiso, o validaciones específicas por edad

2. **Curso:**

   * Nombre del curso
   * Tipo (práctico / teórico)
   * Duración real por clase
   * Horario de clase
   * Instructor
   * Vehículo asignado
   * Modalidad especial (flexible, duración variable)

3. **Horario:**

   * Día
   * Franja horaria
   * Profesor
   * Vehículo
   * Capacidad disponible
   * Estado: reservado / libre

4. **Pago:**

   * **Validación:** Realizada FUERA del sistema (caja/mostrador físico)
   * **Confirmación en sistema:** estado_pago='completado' cuando se registra en inscripción
   * Monto
   * Fecha de inscripción (NO fecha de pago física)
   * Forma de pago (QR / efectivo) - referencia
   * Número de factura / comprobante (referencia externa)
   * Método de pago: Tarjeta crédito, Transferencia, Efectivo, Cheque, etc.

5. **Documentos:**

   * Generación en sistema: NO aplicable en esta fase
   * Los documentos son gestión física externa:
     * Factura / Recibo: Emitida por caja
     * Hoja de horario de clases: Impresa por inscriptor
   * No se requiere generación automática de PDF desde sistema

---

## **4. Problemas actuales detectados**

* Doble inscripción en mismo horario, mismo profesor, mismo vehículo
* Registro manual propenso a errores:

  * Nombres mal escritos
  * Número de carnet incorrecto
  * Teléfono incorrecto
  * Edad incorrecta
* Falta de sincronización automática entre Excel y sistema
* Rotación incorrecta del vehículo automático
* Dificultad en visualizar disponibilidad por profesor y vehículo
* Falta de backup adecuado de horarios
* Estadísticas de pagos requerían manejo manual previo

---

## **5. Requisitos funcionales implícitos**

* Registro de alumnos y validación de datos básicos
* Selección y reserva de horarios según disponibilidad de:

  * Profesor
  * Vehículo
* Gestión de cursos con múltiples modalidades (prácticas / teóricas / especiales)
* Gestión de pagos y generación automática de resúmenes mensuales
* Generación e impresión de documentos:

  * Horario de clases
  * Factura / recibo
  * Documento de compromiso (menores)
* Visualización unificada de horarios por profesor y vehículo
* Registro de curso especial con clases flexibles y contabilización independiente
* Backup automático y sincronización en múltiples máquinas
* Alertas ante conflictos de inscripción

---

## **6. Reglas de negocio especiales (cursos especiales)**

* Duración y distribución de horas flexibles, adaptadas al alumno.
* Cada clase se registra individualmente:

  * Tipo: práctica o teórica
  * Horario
  * Instructor
  * Vehículo
* Horas totales de curso especial: suma de duración real de cada clase.
* Un alumno puede tener múltiples inscripciones a cursos especiales, contabilizadas independientemente.
* No dependen de valores predefinidos de horas por curso.

---

## **7. Reglas generales de negocio**

* **Inscripción:** Requiere estado_pago='completado' ANTES de registrarse en sistema
* **Pago:** Validado FUERA del sistema, confirmado en sistema estableciendo estado_pago
* **Datos alumno:** Nombre completo, carnet, fecha nacimiento, teléfono (uniforme para todos)
* **Restricciones por edad:** Decisión física/legal externa, NO parte de lógica del sistema
* **Recursos limitados:** 4 vehículos (3 manuales, 1 automático), 5 instructores, 5 horarios fijos
* **Anticonflicto:** Validar instructor, vehículo, alumno sin conflictos en horario solicitado
* **Sistema multi-máquina:** Inscripción simultánea en 3 computadoras, sincronización automática
* **Visualización:** Mostrar disponibilidad de horarios, instructor, vehículo
* **Backup:** Sistema debe funcionar incluso si falla una máquina

---


