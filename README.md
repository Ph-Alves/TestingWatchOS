# TestingWatchOS ⌚️

Repositório de estudos sobre **watchOS** e os frameworks do ecossistema Apple Watch, com pequenos projetos práticos para explorar APIs, padrões de UI e integrações nativas do relógio.

## Objetivo

Servir como laboratório pessoal para aprender e experimentar:

- Construção de interfaces com **SwiftUI** voltadas para telas pequenas e a Digital Crown
- Comunicação entre iPhone e Apple Watch
- Sensores e dados de saúde/atividade
- Complicações e widgets de tela de bloqueio
- Notificações e background tasks específicas do watchOS

## Frameworks estudados

| Framework | Uso |
|---|---|
| `SwiftUI` | Interface declarativa das telas do Watch App |
| `WatchKit` | Ciclo de vida e integrações específicas do watchOS |
| `WatchConnectivity` | Troca de dados entre o app iOS e o Watch App |
| `HealthKit` | Leitura/escrita de dados de saúde e atividade |
| `WorkoutKit` | Criação e execução de treinos |
| `CoreMotion` | Acesso a sensores de movimento (acelerômetro, giroscópio) |
| `ClockKit` / `WidgetKit` | Complicações e widgets para a tela do relógio |
| `UserNotifications` | Notificações locais e push no watchOS |

> A tabela é atualizada conforme novos frameworks forem explorados no repositório.

## Estrutura do projeto

```
testingWatch/
├── testingWatch.xcodeproj
├── testingWatch Watch App/        # Código-fonte do Watch App
├── testingWatch Watch AppTests/   # Testes unitários
└── testingWatch Watch AppUITests/ # Testes de UI
```

## Requisitos

- Xcode 16+
- watchOS 10+ (simulador ou dispositivo físico)
- Swift 5.9+

## Como rodar

1. Abra `testingWatch/testingWatch.xcodeproj` no Xcode
2. Selecione um simulador de Apple Watch como destino
3. Rode com `Cmd + R`

## Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.
