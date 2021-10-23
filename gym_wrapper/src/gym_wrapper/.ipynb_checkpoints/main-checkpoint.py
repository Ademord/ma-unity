def main():
    from argparse import ArgumentParser

    parser = ArgumentParser(fromfile_prefix_chars='@')
    parser.add_argument('--run-dir')  # ex. python /app/main.py --run-dir='baseAgents/run61.speed/'
    
    args = parser.parse_args()
    
    import settings
    settings.settings_controller.initialize(args)

    import trainer
    m_Trainer = trainer.Trainer(settings.callback)

    # m_Trainer.test_compatibility()
    m_Trainer.model_pipeline()

    settings.settings_controller.close_all()


if __name__ == '__main__':
    main()
